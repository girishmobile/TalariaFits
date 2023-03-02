import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:talaria/provider/search_provider.dart';
import 'package:talaria/services/admin_service.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/show_message.dart';

class AddOutfitsProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();

  bool isLoading = false;
  final SearchProvider _searchProvider = Provider.of<SearchProvider>(Get.context!, listen: false);

  // //this list contains the photos of the shoes user added
  // List<File> addedImages = [];

  //this list contains the photos of the shoes user selected
  List<String> selectedImages = [];

  //this map contains the URLs of the outfits for this pair of shoes
  Map<String, String> outfitsImages = {};

  //this map contains images that were deleted by the user
  Map<String, String> deletedImages = {};

  //this String is an ID of the shoe the user is adding adding outfits for
  String shoesID = "";

  ///this function initializes variables for this page
  void initializeVariables({required String shoesID, required Map<String, String> outfitsImagesURLs}) {
    for (var outfitImageEntry in outfitsImagesURLs.entries) {
      outfitsImages.putIfAbsent(outfitImageEntry.key, () => outfitImageEntry.value);
    }
    //outfitsImages.c outfitsImagesURLs;
    this.shoesID = shoesID;
    deletedImages = {};
    notifyListeners();
  }

  ///this function disposes variables for this page
  void disposeVariables() {
    outfitsImages.clear();
    shoesID = "";
    selectedImages = [];
    deletedImages.clear();
    notifyListeners();
  }

  ///this function gets outfits from the gallery and puts them into the app
  Future<void> getImagesFromGallery() async {
    List<File>? images = await _adminService.getShoesImagesFromGallery(imageLimit: 12);
    if (images != null) {
      for (var image in images) {
        outfitsImages.putIfAbsent("${image.path.hashCode}", () => image.path);
      }
      notifyListeners();
    }
  }

  ///this function removes all the photos user has selected
  void removeSelectedImages() {
    for (String selectedOutfitId in selectedImages) {
      if (outfitsImages[selectedOutfitId]!.contains("https://")) {
        deletedImages.putIfAbsent(selectedOutfitId, () => outfitsImages[selectedOutfitId]!);
      }
      outfitsImages.remove(selectedOutfitId);
    }
    //print("DELETED IMAGES: $deletedImages");
    selectedImages = [];
    notifyListeners();
  }

  ///this function is triggered when the user clicks on an outfit image
  void selectImage(String outfitID) {
    if (selectedImages.contains(outfitID)) {
      selectedImages.remove(outfitID);
    } else {
      selectedImages.add(outfitID);
    }
    notifyListeners();
  }

  ///this function gets triggered when the user presses the add outfits button
  ///on success, it shows a a success message
  ///on failure, it shows an error message
  void onUploadClicked() async {
    try {
      isLoading = true;
      notifyListeners();
      int deleteOutfitImagesFromFirebaseStorageResult = -1;
      if (deletedImages.isNotEmpty) {
        //first, we need to delete the images from Firebase Storage that the user deleted in here
        deleteOutfitImagesFromFirebaseStorageResult = await _adminService.deleteOutfitImagesFromFirebaseStorage(shoesID: shoesID, imagesToDelete: deletedImages);
      }
      if (deleteOutfitImagesFromFirebaseStorageResult != 1) {
        //new images needed to upload
        Map<String, String> newlyAddedOutfitsImagesThatNeedUpload = {};
        Map<String, String> originalOutfitsImagesURLs = {};

        for (var imageEntry in outfitsImages.entries) {
          if (!imageEntry.value.contains("https://")) {
            newlyAddedOutfitsImagesThatNeedUpload.putIfAbsent(imageEntry.key, () => imageEntry.value);
          } else {
            originalOutfitsImagesURLs.putIfAbsent(imageEntry.key, () => imageEntry.value);
          }
        }
        var uploadOutfitPhotosToFirebaseResponseURLs = await _adminService
            .uploadOutfitPhotosToFirebase(shoesID: shoesID, newlyAddedImages: newlyAddedOutfitsImagesThatNeedUpload, originalImages: originalOutfitsImagesURLs);

        if (uploadOutfitPhotosToFirebaseResponseURLs != null) {

          //all images URLs that will be updated for the SearchProvider
          Map<String, String> allOutfitsImagesURLs = {};
          //adding the newly added uploaded URLs and old URLs into the same map
          allOutfitsImagesURLs.addAll(uploadOutfitPhotosToFirebaseResponseURLs);
          allOutfitsImagesURLs.addAll(originalOutfitsImagesURLs);
          //updating the SearchProvider list of shoes with allOutfitsImagesURLs
          _searchProvider.updateShoesOutfitImages(shoeID: shoesID, outfitImages: allOutfitsImagesURLs);
          //closing the page because operation was successful
          Get.close(1);

          //photos were added successfully
          ShowMessage.inSnackBar(title: "Success", message: "Outfits were successfully updated!", color: Colors.green);
        } else {
          //there was some error
          ShowMessage.inSnackBar(title: "Error Occurred!", message: "Couldn't update outfits. Please try again.", color: AppColors.redColor);
        }
      } else {
        //there was some error
        ShowMessage.inSnackBar(title: "Error Occurred!", message: "Couldn't update outfits. Please try again.", color: AppColors.redColor);
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ShowMessage.inSnackBar(title: "Error Occurred!", message: "Couldn't update outfits. Please try again.", color: AppColors.redColor);
    }

  }
}
