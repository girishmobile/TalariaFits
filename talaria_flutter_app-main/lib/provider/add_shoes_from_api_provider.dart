import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talaria/models/shoes_model.dart';
import 'package:talaria/services/admin_service.dart';
import 'package:talaria/constants/constants.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import '../models/sneaker_model.dart';
import '../services/sneakers_service.dart';
import '../utils/colors.dart';
import '../utils/show_message.dart';

class AddShoesFromAPIProvider with ChangeNotifier {
  //this controller is used on AddShoesFromAPISearchPage for loading more sneakers as admin scrolls down
  final RefreshController refreshController = RefreshController(
      initialRefresh: false,
      initialLoadStatus: LoadStatus.idle,
      initialRefreshStatus: RefreshStatus.idle);

  //this is a variable that contains the number of the current page that is
  //displayed on the AddShoesFromAPISearchPage. Used for pagination loading
  int currentPage = 0;

  //this variable is used to display a loading indicator
  bool isLoading = false;

  //this list contains the shoes that are retrieved from the API
  List<APISneakerModel> sneakerListToDisplay = [];
  //SneakersService variable
  final SneakersService _sneakersService = SneakersService();

  //AdminService variable
  final AdminService _adminService = AdminService();

  ///this function requests a search from the service file to populate the sneakers retrieved
  ///from the API by a certain search query
  void populateShoesListToDisplayBySearchQuery(String query) {
    if (query != "") {
      _searchSneakersByQueryFromAPI(query);
    } else {
      sneakerListToDisplay = [];
      currentPage = 0;
      notifyListeners();
    }
  }

  getSneakersListByBrand(String brand) async {
    if (brand != "") {
      _getSneakersByBrandFromAPI(brand);
    }
  }

  ///this function makes a service call that gets the shoes from the sneakers API
  void _getSneakersByBrandFromAPI(String brand) async {
    isLoading = true;
    notifyListeners();
    var sneakers = await _sneakersService.getSneakersByBrand(brand);
    //checking if the sneakers returned from the API are null
    if (sneakers == null) {
      isLoading = false;
      notifyListeners();
      return;
    }
    for (var sneaker in sneakers) {
      sneakerListToDisplay.add(APISneakerModel.fromMap(sneaker));
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  ///this function makes a service call that gets the shoes from the sneakers API
  void _searchSneakersByQueryFromAPI(String query) async {
    //only display loading indicator on the first time loading. For refresh, we don't need to show a Loader()
    if (currentPage == 0) {
      isLoading = true;
      notifyListeners();
    }
    var sneakers = await _sneakersService.searchSneakersByQuery(
        query: query, page: currentPage);
    //checking if the sneakers returned from the API are NULL and quit if they are NULL
    if (sneakers == null) {
      isLoading = false;
      notifyListeners();
      return;
    }
    for (var sneaker in sneakers) {
      sneakerListToDisplay.add(APISneakerModel.fromMap(sneaker));
      notifyListeners();
    }
    //only want to update the page index if the sneakers list we just got is not empty
    if (sneakers.isNotEmpty) {
      currentPage++;
    }
    isLoading = false;
    refreshController.loadComplete();
    notifyListeners();
  }

  ///this function adds the API shoe to the Firebase Firestore database
  void addShoeToFirebaseFirestore(APISneakerModel sneakerModel) async {
    isLoading = true;
    notifyListeners();
    //converting APISneakerModel into ShoeDataModel
    int genderType = 0;
    if (sneakerModel.gender == "Men") {
      genderType = 0;
    } else if (sneakerModel.gender == "Women") {
      genderType = 1;
    } else {
      genderType = 2;
    }
    String brand = sneakerModel.brand.toLowerCase();
    brand = toBeginningOfSentenceCase(brand)!;
    ShoesDataModel shoesDataModel = ShoesDataModel(
        genderType: genderType,
        mainImage: sneakerModel.image.original,
        size: AppConstants.shoeSizes,
        name: sneakerModel.name,
        id: sneakerModel.id,
        description: sneakerModel.story,
        brand: brand,
        createdAt: Timestamp.now());
    //checking if the shoe already exists
    int isShoeExists =
        await _adminService.checkIfShoeAlreadyInFirestore(shoesDataModel.id!);
    int isBrandExists = await _adminService.checkIfBrandAlreadyExists(brand);
    //means brand doesn't exist
    if (isBrandExists == 0) {
      int addBrandResult = await _adminService.addBrand(brand);
      if (addBrandResult == 1) {
        //means some unexpected error occurred, then we want to quit this function
        ShowMessage.inSnackBar(
            title: "Failed",
            message: "An error occurred. Check your internet connections.",
            color: AppColors.redColor);
        isLoading = false;
        notifyListeners();
        return;
      }
    } else if (isBrandExists == 2) {
      //means some unexpected error occurred, then we want to quit this function
      ShowMessage.inSnackBar(
          title: "Failed",
          message: "An error occurred. Check your internet connections.",
          color: AppColors.redColor);
      isLoading = false;
      notifyListeners();
      return;
    }
    //means shoe doesn't exist
    if (isShoeExists == 0) {
      int uploadResult =
          await _adminService.uploadAPISneakerToFirebase(shoesDataModel);
      if (uploadResult == 0) {
        ShowMessage.inSnackBar(
            title: "Congratulations!",
            message: "The shoes were successfully added.",
            color: Colors.green);
      } else {
        ShowMessage.inSnackBar(
            title: "Failed",
            message: "An error occurred.",
            color: AppColors.redColor);
      }
    } else {
      ShowMessage.inSnackBar(
          title: "Failed",
          message: "Shoes already exist in your database.",
          color: AppColors.redColor);
    }
    isLoading = false;
    notifyListeners();
  }

  ///this function clears a displayed array of sneakers and page displayed index
  void clearPageOutputs() {
    sneakerListToDisplay = [];
    currentPage = 0;
    notifyListeners();
  }
}
