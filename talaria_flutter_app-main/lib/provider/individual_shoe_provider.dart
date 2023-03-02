import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shoes_model.dart';
import '../services/admin_service.dart';
import '../utils/colors.dart';
import '../utils/confirm_dialog.dart';
import '../constants/constants.dart';
import '../utils/show_message.dart';
import 'dashboard_provider.dart';

class IndividualShoeProvider with ChangeNotifier {
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

  late Map<String, List<String>> imagesURLs = {};
  late Set<String> modifiedColors = {};
  String mainImageURL = "";

  late TextEditingController modelNameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;


  int validateShoesEditingInputs() {
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
    else if (selectedMainImage == null && mainImageURL.isEmpty) {
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
    else if (selectedImages.length + imagesURLs.length != selectedColors.length) {
      ShowMessage.inSnackBar(
          title: "OOPS!",
          message: "Number of colors and images must match.",
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
    for (var images in imagesURLs.values) {
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
    if (newColor.isNotEmpty && !selectedColors.contains(newColor) && !imagesURLs.containsKey(newColor)) {
      selectedColors.add(newColor);
      selectedImages.putIfAbsent(newColor, () => []);
      modifiedColors.add(newColor);
    }
    notifyListeners();
  }

  void removeColor(String color) {
    selectedColors.remove(color);
    if (selectedImages.containsKey(color)) {
      selectedImages.remove(color);
    } else {
      imagesURLs.remove(color);
      modifiedColors.add(color);
    }
    notifyListeners();
  }

  void modifyColorImages(String color) {
    if (!selectedImages.containsKey(color)) {
      imagesURLs.remove(color);
      modifiedColors.add(color);
      selectedImages.putIfAbsent(color, () => []);
    }
    notifyListeners();
  }

  void genderClicked(int clickedGender) {
    selectedGenderType = clickedGender;
    notifyListeners();
  }


  // void removeMainImageFromFirestore() {
  //   _adminService
  // }

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


  ///this function updates the shoes
  Future<void> updateShoes(BuildContext context, ShoesDataModel originalShoesDataModel) async {
    isLoading = true;
    notifyListeners();


    ShoesDataModel updatedShoesDataModel = originalShoesDataModel;
    updatedShoesDataModel.brand = selectedBrand;
    updatedShoesDataModel.name = selectedModelName;
    updatedShoesDataModel.genderType = selectedGenderType;
    updatedShoesDataModel.size = selectedSizes;
    updatedShoesDataModel.description = selectedDescription;

    //deleting the firebase storage for modified colors and getting download URLs for the newly uploaded ones
    int result = await removeModifiedColorsFromFirebaseStorageAndUploadNewOnes(originalShoesDataModel.id!);
    if (result == 1) {
      ShowMessage.inSnackBar(
          title: "OOPS!",
          message: "Error occurred. Please try again.",
          color: Colors.red);
      isLoading = false;
      notifyListeners();
      return;
    } else {
      updatedShoesDataModel.images = imagesURLs;
    }
    //checking if need to update main image
    if (selectedMainImage != null) {
      String? downloadURL = await removeMainImageFromFirebaseStorageAndGetNewDownloadURL(originalShoesDataModel.id!);
      if (downloadURL != null) {
        updatedShoesDataModel.mainImage = downloadURL;
      } else {
        ShowMessage.inSnackBar(
            title: "OOPS!",
            message: "Error occurred. Please try again.",
            color: Colors.red);
        isLoading = false;
        notifyListeners();
        return;
      }
    }
    int updateShoesInFirestoreResult = await _adminService.updateShoesInFirestore(updatedShoesDataModel);
    if (updateShoesInFirestoreResult == 1) {
      ShowMessage.inSnackBar(
          title: "OOPS!",
          message: "Error occurred. Please try again.",
          color: Colors.red);
      isLoading = false;
      notifyListeners();
      return;
    }
    ShowMessage.inSnackBar(
        title: "Congratulations!",
        message: "You successfully updated the shoes.",
        color: Colors.green);
    clearEditShoesPage();
    Navigator.pop(context);
    isLoading = false;
    notifyListeners();
  }


  Future<int> removeModifiedColorsFromFirebaseStorageAndUploadNewOnes(String shoesId) async {
    int result1 = await _adminService.removeSpecificColorsFromFirebaseStorage(colors: modifiedColors, shoesId: shoesId);
    if (result1 == 0) {
      for (MapEntry entry in selectedImages.entries) {
        List<String>? downloadURLs = await _adminService.uploadImagesToFirebaseStorage(colorName: entry.key, shoesId: shoesId, newFiles: entry.value);
        if (downloadURLs != null) {
          imagesURLs.putIfAbsent(entry.key, () => downloadURLs);
        } else {
          return 1;
        }
      }
    } else {
      return 1;
    }
    return 0;
  }


  Future<String?> removeMainImageFromFirebaseStorageAndGetNewDownloadURL(String shoesId) async {
    String? downloadURL = await _adminService.replaceShoesMainImage(mainImageFile: selectedMainImage!, shoesId: shoesId);
    return downloadURL;
  }

  Future<void> removeShoes(BuildContext context, ShoesDataModel shoesDataModel) async {
    isLoading = true;
    notifyListeners();
    ConfirmDialog.showAlertDialog(context, header: "Are you sure?", message: "This will delete the shoes forever?", onConfirm: () async {
      //popping confirmation field
      Navigator.pop(context);
      int response = await _adminService.removeShoes(shoesDataModel.id!);
      if (response == 0) {
        ShowMessage.inSnackBar(
            title: "Congratulations!",
            message:
            "Shoes were removed successfully",
            color: AppColors.purpleTextColor);
        _dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
        _dashboardProvider.removeShoesInList(shoesDataModel);
        Navigator.pop(context);
      } else {
        ShowMessage.inSnackBar(
            title: "Oops!",
            message:
            "An error occurred. Please try again!",
            color: AppColors.redColor);
      }
    }, onCancel: () {
      Navigator.pop(context);
    });
    isLoading = false;
    notifyListeners();
  }


  void fillIndividualShoesPageFields({required ShoesDataModel shoesDataModel}) {
    modelNameController.text = shoesDataModel.name!;
    selectedModelName = shoesDataModel.name!;
    descriptionController.text = shoesDataModel.description!;
    selectedDescription = shoesDataModel.description!;
    selectedSizes = shoesDataModel.size!;
    for (MapEntry<String, List<String>> entry in shoesDataModel.images!.entries) {
      selectedColors.add(entry.key);
      imagesURLs.putIfAbsent(entry.key, () => []);
      for (String imageURL in entry.value) {
        imagesURLs[entry.key]!.add(imageURL);
      }
    }
    selectedGenderType = shoesDataModel.genderType!;
    selectedBrand = shoesDataModel.brand!;
    mainImageURL = shoesDataModel.mainImage!;
    notifyListeners();
  }

  void clearEditShoesPage() {
    selectedImages = {};
    selectedColors = [];
    selectedGenderType = 0;
    selectedSizes = [];
    selectedMainImage = null;
    modifiedColors = {};
    imagesURLs = {};
    mainImageURL = "";
    notifyListeners();
  }

}