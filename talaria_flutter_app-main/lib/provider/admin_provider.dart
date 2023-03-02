import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talaria/constants/fb_collections.dart';
import 'package:talaria/models/brands_model.dart';
import 'package:talaria/models/shoes_model.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/services/admin_service.dart';
import 'package:talaria/constants/constants.dart';
import '../services/sneakers_service.dart';
import '../utils/colors.dart';
import '../utils/show_message.dart';

class AdminProvider with ChangeNotifier {

  late DashboardProvider _dashboardProvider;
  final AdminService _adminService = AdminService();


  //these variables are used for a page that creates a shoe
  late String selectedBrand = "";
  late String selectedModelName = "";
  late String selectedDescription = "";
  late List<double> selectedSizes = [];
  late List<String> selectedColors = [];
  late Map<String, List<File>> selectedImages = {};
  File? selectedMainImage;
  late int selectedGenderType = 0; //0 == male, 1 == female, 2 == both


  late TextEditingController modelNameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  Future<void> addBrand(BuildContext context, String newBrand) async {
    isLoading = true;
    notifyListeners();
    int response = await _adminService.addBrand(newBrand);
    if (response == 0) {
      ShowMessage.inSnackBar(
          title: "Congratulations!",
          message:
          "Brand was added successfully",
          color: AppColors.purpleTextColor);
      _dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
      _dashboardProvider.addToBrandsList(BrandsModel(name: newBrand, createdAt: Timestamp.now()));
    } else {
      ShowMessage.inSnackBar(
          title: "Oops!",
          message:
          "An error occurred. Please try again!",
          color: AppColors.redColor);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<int> verifyBrand(String newBrand) async {
    if (newBrand.isEmpty) {
      ShowMessage.inSnackBar(
          title: "Oops!",
          message:
          "Brand name can't be empty.",
          color: AppColors.redColor);
      return 1;
    }
    try {
      var brandsCollectionRef = FBCollections.brands;
      var brandDoc = await brandsCollectionRef.doc(newBrand).get();
      if (brandDoc.exists) {
        ShowMessage.inSnackBar(
            title: "Oops!",
            message:
            "This brand already exists.",
            color: AppColors.redColor);
        return 1;
      }
      return 0;
    } catch (error) {
      return 1;
    }
  }

  Future<void> removeBrand(BuildContext context, BrandsModel brandsModel) async {
    isLoading = true;
    notifyListeners();
    int response = await _adminService.removeBrand(brandsModel.name!);
    if (response == 0) {
      ShowMessage.inSnackBar(
          title: "Congratulations!",
          message:
          "Brand was removed successfully",
          color: AppColors.purpleTextColor);
      _dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
      _dashboardProvider.removeFromBrandList(brandsModel);
    } else {
      ShowMessage.inSnackBar(
          title: "Oops!",
          message:
          "An error occurred. Please try again!",
          color: AppColors.redColor);
    }
    Navigator.pop(context);
    isLoading = false;
    notifyListeners();
  }



  int validateShoesCreationInputs() {
    //checking if the brand was selected
    if (selectedBrand.isEmpty) {
      ShowMessage.inSnackBar(
          title: "OOPS!",
          message: "Please select a brand first.",
          color: Colors.red);
      return 1;
    }
    else if (selectedModelName.isEmpty) {
      ShowMessage.inSnackBar(
          title: "OOPS!",
          message: "Please enter shoes model first.",
          color: Colors.red);
      return 1;
    }
    else if (selectedDescription.isEmpty) {
      ShowMessage.inSnackBar(
          title: "OOPS!",
          message: "Please enter description first.",
          color: Colors.red);
    }
    else if (selectedGenderType == -1) {
      ShowMessage.inSnackBar(
          title: "OOPS!",
          message: "Please select a gender.",
          color: Colors.red);
    }
    else if (selectedMainImage == null) {
      ShowMessage.inSnackBar(
          title: "OOPS!",
          message: "Must select a main image.",
          color: Colors.red);
      return 1;
    }
    else if (selectedSizes.isEmpty) {
      ShowMessage.inSnackBar(
          title: "OOPS!",
          message: "Must select at least 1 size.",
          color: Colors.red);
      return 1;
    }
    else if (selectedColors.isEmpty) {
      ShowMessage.inSnackBar(
          title: "OOPS!",
          message: "Must select at least 1 color.",
          color: Colors.red);
      return 1;
    }
    else if (selectedImages.length != selectedColors.length) {
      ShowMessage.inSnackBar(
          title: "OOPS!",
          message: "Number of colors and Images must match.",
          color: Colors.red);
      return 1;
    }
    for (var images in selectedImages.values) {
      if (images.isEmpty) {
        ShowMessage.inSnackBar(
            title: "OOPS!",
            message: "Images for at least one color are missing.",
            color: Colors.red);
        return 1;
      }
    }
    return 0;
  }



  void updateSelectedBrand(String newBrand) {
    selectedBrand = newBrand;
    notifyListeners();
  }

  void updateSelectedModelName(String newModelName) {
    selectedModelName = newModelName;
    notifyListeners();
  }

  void updateDescription(String newDescription) {
    selectedDescription = newDescription;
    notifyListeners();
  }

  void shoeSizeClicked(double shoeSize) {
    if (selectedSizes.contains(shoeSize)) {
      selectedSizes.remove(shoeSize);
    } else {
      selectedSizes.add(shoeSize);
    }
    selectedSizes.sort();
    notifyListeners();
  }

  void selectAllSizes() {
    selectedSizes = [];
    for (double size in AppConstants.shoeSizes) {
      selectedSizes.add(size);
    }
    notifyListeners();
  }

  void addColor(String newColor) {
    if (newColor.isNotEmpty && !selectedColors.contains(newColor)) {
      selectedColors.add(newColor);
      selectedImages.putIfAbsent(newColor, () => []);
    }
    notifyListeners();
  }

  void removeColor(String color) {
    selectedColors.remove(color);
    selectedImages.remove(color);
    notifyListeners();
  }

  void genderClicked(int clickedGender) {
    selectedGenderType = clickedGender;
    notifyListeners();
  }

  void updateImages({required List<File> images, required String color}) {
    if (selectedImages.containsKey(color)) {
      selectedImages['color'] = images;
    } else {
      selectedImages.putIfAbsent(color, () => images);
    }
    notifyListeners();
  }

  Future<void> getImagesFromGallery({required String color}) async {
    List<File>? images = await _adminService.getShoesImagesFromGallery(imageLimit: 6);
    if (images != null) {
      selectedImages[color] = images;
      notifyListeners();
    }
  }

  Future<void> getMainImageFromGallery() async {
    List<File>? image = await _adminService.getShoesImagesFromGallery(imageLimit: 1);
    if (image != null && image.isNotEmpty) {
      selectedMainImage = image[0];
      notifyListeners();
    }
  }


  void submitShoes(BuildContext context) {
    int validationResult = validateShoesCreationInputs();
    if (validationResult == 0) {
      Timestamp currentTime = Timestamp.now();
      String shoeId = currentTime.seconds.toString();
      ShoesDataModel _shoesDataModel = ShoesDataModel(
          genderType: selectedGenderType,
          images: {},
          mainImage: selectedMainImage!.path,
          size: selectedSizes,
          name: selectedModelName,
          reference: FBCollections.shoes.doc(shoeId),
          id: shoeId,
          description: selectedDescription,
          brand: selectedBrand,
          createdAt: Timestamp.now()
      );
      addShoes(context, _shoesDataModel);
    }
  }

  Future<void> addShoes(BuildContext context, ShoesDataModel shoesDataModel) async {
    isLoading = true;
    notifyListeners();
    int response = await _adminService.uploadShoesToFirestore(shoesDataModel, selectedImages);
    if (response == 0) {
      ShowMessage.inSnackBar(
          title: "Congratulations!",
          message:
          "Shoes were added successfully",
          color: AppColors.purpleTextColor);
      clearAddShoesPage();
      //going back to admin home page
      Navigator.pop(context);
    } else {
      ShowMessage.inSnackBar(
          title: "Oops!",
          message:
          "An error occurred. Please try again!",
          color: AppColors.redColor);
    }
    isLoading = false;
    notifyListeners();
  }

  void clearAddShoesPage() {
    selectedImages = {};
    selectedColors = [];
    selectedGenderType = 0;
    selectedSizes = [];
    selectedMainImage = null;
    notifyListeners();
  }
}