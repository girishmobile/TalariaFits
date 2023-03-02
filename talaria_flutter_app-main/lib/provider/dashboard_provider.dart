import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talaria/constants/fb_collections.dart';
import 'package:talaria/models/brands_model.dart';
import 'package:talaria/models/gender_type_model.dart';
import 'package:talaria/models/my_closet_model.dart';
import 'package:talaria/models/shoes_model.dart';
import 'package:talaria/models/user_model.dart';
import 'package:talaria/services/sneakers_service.dart';
import 'package:talaria/utils/show_message.dart';
import '../models/my_favourite_model.dart';

class DashboardProvider extends ChangeNotifier {
  UserModel userData = UserModel();
  List<ShoesDataModel> shoeList = [];
  List<MyFavouriteModel> favouriteList = [];
  List<BrandsModel> brandList = [];
  List<GenderTypeModel> genderList = [];
  List<MyClosetModel> closetList = [];

//GIRISH CHAUHAN
  final SneakersService _sneakersService = SneakersService();

  StreamSubscription? shoesSubscription;

  bool pushNotifications = false;
  bool emailNotifications = false;
  bool isLoading = false;

  void setUserData(UserModel userModel) {
    userData = userModel;
    notifyListeners();
  }

  void clearAllData() {
    userData = UserModel();
    favouriteList = [];
    closetList = [];
    notifyListeners();
  }

  //start and stop loading
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  // GET GENDER TYPE DATA
  Future<void> getGenderTypeData() async {
    try {
      QuerySnapshot q = await FBCollections.genderType.get();
      genderList.clear();
      q.docs.forEach((element) {
        genderList.add(GenderTypeModel.fromJson(element.data()));
      });
      notifyListeners();
    } catch (e) {}
  }

  // GET BRAND DATA
  Future<void> getBrandsData() async {
    try {
      QuerySnapshot q = await FBCollections.brands.get();
      brandList.clear();
      q.docs.forEach((element) {
        brandList.add(BrandsModel.fromJson(element.data()));
      });
      notifyListeners();
    } catch (e) {}
  }

  Future<void> addToCloset(MyClosetModel closetModel) async {
    try {
      closetList.add(closetModel);
      notifyListeners();
      await FBCollections.users
          .doc(userData.email)
          .collection("MyCloset")
          .doc(closetModel.shoesId)
          .set(closetModel.toJson());
      ShowMessage.inSnackBar(
          title: "Congratulations!",
          message: "Product is added to closet",
          color: Colors.lightGreen);
      stopLoading();
    } catch (e) {
      stopLoading();
    }
  }

  checkClosetAdded({required String shoeId, required double selectedSize}) {
    for (var closetItem in closetList) {
      if (closetItem.shoesId == shoeId &&
          closetItem.selectedSize == selectedSize) {
        return true;
      }
    }
    return false;
  }

  Future<void> removeFromCloset(BuildContext context, String shoesId) async {
    try {
      int cloIndex =
          closetList.indexWhere((element) => element.shoesId == shoesId);
      if (cloIndex != -1) {
        closetList.removeAt(cloIndex);
        await FBCollections.users
            .doc(userData.email)
            .collection("MyCloset")
            .doc(shoesId)
            .delete();
        ShowMessage.inSnackBar(
            title: "Congratulations!",
            message: "Product is removed from closed",
            color: Colors.lightGreen);
        notifyListeners();
        Navigator.pop(context);
      }
      stopLoading();
    } catch (e) {
      stopLoading();
    }
  }

  Future<void> addToFav(MyFavouriteModel favouriteModel) async {
    favouriteList.add(favouriteModel);
    try {
      await FBCollections.users
          .doc(userData.email)
          .collection("MyFavourites")
          .doc(favouriteModel.shoesId)
          .set(favouriteModel.toJson());
      stopLoading();
    } catch (e) {
      stopLoading();
    }
    notifyListeners();
  }

  Future<void> removeFav(int index, String shoesId) async {
    try {
      favouriteList.removeAt(index);
      await FBCollections.users
          .doc(userData.email)
          .collection("MyFavourites")
          .doc(shoesId)
          .delete();
      notifyListeners();
      stopLoading();
    } catch (e) {
      stopLoading();
    }
  }

  addRemoveFav(
    String shoesId,
  ) {
    int indexShoes =
        favouriteList.indexWhere((element) => element.shoesId == shoesId);
    if (indexShoes == -1) {
      MyFavouriteModel favouriteModel = MyFavouriteModel(
          createdAt: Timestamp.now(), status: "1", shoesId: shoesId);
      addToFav(favouriteModel);
    } else {
      removeFav(indexShoes, shoesId);
    }
    notifyListeners();
  }

  checkFav(
    String shoesId,
  ) {
    int indexShoes =
        favouriteList.indexWhere((element) => element.shoesId == shoesId);
    if (indexShoes == -1) {
      return false;
    } else {
      return true;
    }
  }

  getClosetList() async {
    try {
      QuerySnapshot snap = await FBCollections.users
          .doc(userData.email)
          .collection("MyCloset")
          .get();
      snap.docs.forEach((element) async {
        MyClosetModel myClosetModel = MyClosetModel.fromJson(element.data());
        var shoeDocument =
            await FBCollections.shoes.doc(myClosetModel.shoesId).get();
        if (!shoeDocument.exists) {
          //if it doesn't exists in the list of all shoes anymore, then we have to remove it
          await FBCollections.users
              .doc(userData.email)
              .collection("MyCloset")
              .doc(myClosetModel.shoesId)
              .delete();
        } else {
          //else, we are adding that document normally
          closetList.add(MyClosetModel.fromJson(element.data()));
          notifyListeners();
        }
      });
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  getFavList() async {
    try {
      QuerySnapshot snap = await FBCollections.users
          .doc(userData.email)
          .collection("MyFavourites")
          .get();
      snap.docs.forEach((element) async {
        //checking if this shoe still exists in Firestore. If it doesn't, we delete it
        MyFavouriteModel favouriteModel =
            MyFavouriteModel.fromJson(element.data());
        var shoeDocument =
            await FBCollections.shoes.doc(favouriteModel.shoesId).get();
        if (!shoeDocument.exists) {
          //if it doesn't exists in the list of all shoes anymore, then we have to remove it
          await FBCollections.users
              .doc(userData.email)
              .collection("MyFavourites")
              .doc(favouriteModel.shoesId)
              .delete();
        } else {
          //else, we are adding that document normally
          favouriteList.add(MyFavouriteModel.fromJson(element.data()));
          notifyListeners();
        }
      });
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  getAllShoesList() async {
    try {
      Stream<QuerySnapshot> snap = FBCollections.shoes.snapshots();
      shoesSubscription ??= snap.listen((event) {
        shoeList = [];
        event.docs.forEach((element) {
          shoeList
              .add(ShoesDataModel.fromJson(element.data(), element.reference));
          notifyListeners();
        });
        shoeList.sort((a, b) {
          var adate = a.createdAt!;
          var bdate = b.createdAt!;
          return bdate.compareTo(adate);
        });
        notifyListeners();
      });
    } catch (e) {
      String error = e.toString();

      log('Error getAllshoes $error');
    }
    notifyListeners();
  }

  List<ShoesDataModel> getTopRatingShoes() {
    List<ShoesDataModel> shoesRatedList = [...shoeList];
    shoesRatedList
        .sort((a, b) => b.shoesRatingValue.compareTo(a.shoesRatingValue));
    return shoesRatedList;
  }

  List<ShoesDataModel> getListByGender(int gender) {
    List<ShoesDataModel> shoesRatedList = [...shoeList];
    return shoesRatedList
        .where((element) => element.genderType == gender)
        .toList();
  }

  List<ShoesDataModel> getListByBrand(String brand) {
    List<ShoesDataModel> shoesRatedList = [...shoeList];
    return shoesRatedList.where((element) => element.brand == brand).toList();
  }

  void addToBrandsList(BrandsModel brandsModel) {
    brandList.insert(0, brandsModel);
    notifyListeners();
  }

  void addToShoesList(ShoesDataModel shoesDataModel) {
    shoeList.insert(0, shoesDataModel);
    notifyListeners();
  }

  void updatedShoesInList(
      {required ShoesDataModel originalShoesDataModel,
      required ShoesDataModel newShoesDataModel}) {
    int index = shoeList.indexOf(originalShoesDataModel);
    if (index != -1) {
      shoeList[index] = newShoesDataModel;
    }
    notifyListeners();
  }

  void removeShoesInList(ShoesDataModel shoesDataModel) {
    shoeList.remove(shoesDataModel);
    notifyListeners();
  }

  void removeFromBrandList(BrandsModel brandsModel) {
    if (brandList.contains(brandsModel)) {
      brandList.remove(brandsModel);
    }
    notifyListeners();
  }

  onInit() {
    isLoading = true;
    notifyListeners();
    getAllShoesList();
    getBrandsData();
    getGenderTypeData();
    getClosetList();
    getFavList();

    isLoading = false;
    notifyListeners();
  }

  onRefresh() {
    isLoading = true;
    notifyListeners();

    getAllShoesList();
    getBrandsData();
    getGenderTypeData();

    isLoading = false;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
