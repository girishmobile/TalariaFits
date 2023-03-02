import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:images_picker/images_picker.dart';
import 'package:talaria/models/shoes_model.dart';

import '../constants/fb_collections.dart';
import '../models/brands_model.dart';

class AdminService {
  Future<int> addBrand(String newBrand) async {
    try {
      BrandsModel brandsModel =
          BrandsModel(name: newBrand, createdAt: Timestamp.now());
      await FBCollections.brands.doc(newBrand).set(brandsModel.toJson());
      return 0;
    } catch (error) {
      return 1;
    }
  }

  ///this function checks if a specified brand already exists
  ///return values:
  ///1 == EXISTS
  ///0 == DNE
  ///2 == unexpected error
  Future<int> checkIfBrandAlreadyExists(String newBrand) async {
    try {
      var brandReference = await FBCollections.brands.doc(newBrand).get();
      if (brandReference.exists) {
        return 1;
      }
      return 0;
    } catch (error) {
      return 2;
    }
  }

  Future<int> removeBrand(String brandName) async {
    try {
      await FBCollections.brands.doc(brandName).delete();
      return 0;
    } catch (error) {
      return 1;
    }
  }

  Future<int> removeShoes(String shoesDataModelId) async {
    try {
      //removing shoes from Firestore
      await FBCollections.shoes.doc(shoesDataModelId).delete();
      //removing shoe images from firebase storage
      var shoeFolders = await FirebaseStorage.instance
          .ref("shoes/$shoesDataModelId/")
          .listAll();
      shoeFolders.prefixes.forEach((folderName) async {
        var folderImages = await FirebaseStorage.instance
            .ref("shoes/$shoesDataModelId/${folderName.name}/")
            .listAll();
        for (var image in folderImages.items) {
          await FirebaseStorage.instance.ref(image.fullPath).delete();
        }
      });
      return 0;
    } catch (e) {
      return 1;
    }
  }

  Future<List<File>?> getShoesImagesFromGallery(
      {required int imageLimit}) async {
    try {
      List<Media>? res = await ImagesPicker.pick(
        pickType: PickType.image,
        quality: 1,
        count: imageLimit,
      );
      List<File> _fileImages = [];
      for (Media media in res ?? []) {
        File newFile = File(media.path);
        _fileImages.add(newFile);
      }
      return _fileImages;
    } catch (e) {
      return null;
    }
  }

  ///this function uploads a shoe to Firestore
  Future<int> uploadShoesToFirestore(ShoesDataModel shoesDataModel,
      Map<String, List<File>> selectedImages) async {
    try {
      await FBCollections.shoes
          .doc(shoesDataModel.id)
          .set(shoesDataModel.toJson());
      int uploadImagesResult =
          await _uploadShoesImages(shoesDataModel, selectedImages);
      if (uploadImagesResult == 1) return 1;
      return 0;
    } catch (e) {
      return 1;
    }
  }

  Future<int> updateShoesInFirestore(ShoesDataModel shoesDataModel) async {
    try {
      await FBCollections.shoes
          .doc(shoesDataModel.id)
          .set(shoesDataModel.toJson());
      return 0;
    } catch (e) {
      return 1;
    }
  }

  ///this function uploads shoe images to Firebase Storage and updates them in respective firestore document
  Future<int> _uploadShoesImages(ShoesDataModel shoesDataModel,
      Map<String, List<File>> selectedImages) async {
    try {
      //this map store image URLs based on a shoe's color
      Map<String, List<String>> shoesImagesURLs = {};

      //uploading main image that will be always on display
      late File mainFile = File(shoesDataModel.mainImage!);
      Reference mainImageStorageRef = await FirebaseStorage.instance
          .ref()
          .child('shoes/${shoesDataModel.id}/main_image/${mainFile.hashCode}');

      UploadTask uploadTask = mainImageStorageRef.putFile(mainFile);
      await uploadTask.then((res) async {
        String imageURL = await res.ref.getDownloadURL();
        await FBCollections.shoes
            .doc(shoesDataModel.id)
            .update({'main_image': imageURL});
      });

      for (var mapEntry in selectedImages.entries) {
        shoesImagesURLs.putIfAbsent(mapEntry.key, () => []);
        for (var file in mapEntry.value) {
          Reference colorImageStorageRef = await FirebaseStorage.instance
              .ref()
              .child(
                  'shoes/${shoesDataModel.id}/${mapEntry.key}/${file.hashCode}');

          UploadTask uploadTask = colorImageStorageRef.putFile(file);
          await uploadTask.then((res) async {
            String imageURL = await res.ref.getDownloadURL();
            shoesImagesURLs[mapEntry.key]!.add(imageURL);
          });
        }
      }
      await FBCollections.shoes
          .doc(shoesDataModel.id)
          .update({"images": shoesImagesURLs});
      return 0;
    } catch (e) {
      return 1;
    }
  }

  //replacing the main image of the shoe inside firebase storage
  Future<String?> replaceShoesMainImage(
      {required File mainImageFile, required String shoesId}) async {
    try {
      late File mainFile = mainImageFile;
      var folderImages = await FirebaseStorage.instance
          .ref("shoes/$shoesId/main_image/")
          .listAll();
      for (var image in folderImages.items) {
        await FirebaseStorage.instance.ref(image.fullPath).delete();
      }
      Reference newImageStorageRef = await FirebaseStorage.instance
          .ref()
          .child('shoes/$shoesId/main_image/${mainFile.hashCode}');
      UploadTask uploadTask = newImageStorageRef.putFile(mainFile);
      var uploadTaskResult = await uploadTask;
      return await uploadTaskResult.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<int> removeSpecificColorsFromFirebaseStorage(
      {required Set<String> colors, required String shoesId}) async {
    try {
      //removing shoe images from firebase storage
      var shoeFolders =
          await FirebaseStorage.instance.ref("shoes/$shoesId/").listAll();
      shoeFolders.prefixes.forEach((folderName) async {
        //only removing the colors from firebase storage that are inside "colors"
        if (colors.contains(folderName.name)) {
          var folderImages = await FirebaseStorage.instance
              .ref("shoes/$shoesId/${folderName.name}/")
              .listAll();
          for (var image in folderImages.items) {
            await FirebaseStorage.instance.ref(image.fullPath).delete();
          }
        }
      });
      return 0;
    } catch (e) {
      return 1;
    }
  }

  //replacing the images of the shoe's specific color inside firebase storage
  Future<List<String>?> uploadImagesToFirebaseStorage(
      {required String shoesId,
      required List<File> newFiles,
      required String colorName}) async {
    try {
      List<String> downloadURLs = [];
      for (File file in newFiles) {
        Reference newImageStorageRef = await FirebaseStorage.instance
            .ref()
            .child('shoes/${shoesId}/$colorName/${file.hashCode}');
        UploadTask uploadTask = newImageStorageRef.putFile(file);
        await uploadTask.then((res) async {
          String imageURL = await res.ref.getDownloadURL();
          downloadURLs.add(imageURL);
        });
      }
      return downloadURLs;
    } catch (e) {
      return null;
    }
  }

  ///this function uploads a shoe to Firestore
  Future<int> uploadAPISneakerToFirebase(ShoesDataModel shoesDataModel) async {
    try {
      await FBCollections.shoes
          .doc(shoesDataModel.id)
          .set(shoesDataModel.toJson());
      return 0;
    } catch (e) {
      return 1;
    }
  }

  ///this function checks if the sneaker already exists in Firebase Firestore
  ///return values:
  ///0 == YES
  ///1 = NO
  Future<int> checkIfShoeAlreadyInFirestore(String id) async {
    try {
      var shoeReference = await FBCollections.shoes.doc(id).get();
      if (shoeReference.exists) {
        return 1;
      }
      return 0;
    } catch (e) {
      return 1;
    }
  }

  ///this function uploads outfit images to Firebase Storage under a shoesID
  ///and updates them in respective firestore shoes document
  ///return values:
  ///shoesImagesURLs == success
  ///null == failure
  Future<dynamic> uploadOutfitPhotosToFirebase(
      {required String shoesID, required Map<String, String> newlyAddedImages, required Map<String, String> originalImages}) async {
    try {
      //this map contains outfit images
      //key == image hash code
      //value == image URL
      Map<String, String> shoesImagesURLs = {};
      for (var image in newlyAddedImages.entries) {
        Reference colorImageStorageRef = FirebaseStorage.instance
            .ref()
            .child('outfits/$shoesID/${image.value.hashCode}');

        UploadTask uploadTask = colorImageStorageRef.putFile(File(image.value));
        await uploadTask.then((res) async {
          String imageURL = await res.ref.getDownloadURL();
          shoesImagesURLs.putIfAbsent(
              "${image.value.hashCode}", () => imageURL);
        });
      }
      //adding original images to the newly added images
      shoesImagesURLs.addAll(originalImages);

      //updating the Firebase object with the outfit images we just added
      await FBCollections.shoes
          .doc(shoesID)
          .update({"outfits_images": shoesImagesURLs});
      return shoesImagesURLs;
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///this function takes in a map of the outfit images URLs user decided to delete.
  ///It goes to FirebaseStorage and deletes every element that the user deleted from there
  ///return values:
  ///0 == success
  ///1 == failure
  Future<int> deleteOutfitImagesFromFirebaseStorage(
      {required String shoesID,
      required Map<String, String> imagesToDelete}) async {
    try {
      //print("DELETING THESE IMAGES: $imagesToDelete");
      //deleting the images
      //removing shoe images from firebase storage
      var shoesOutfitsFolder =
          await FirebaseStorage.instance.ref("outfits/$shoesID/").listAll();
      for (var outfitItem in shoesOutfitsFolder.items) {
        String outfitItemID = outfitItem.fullPath
            .substring(outfitItem.fullPath.lastIndexOf("/") + 1);
        //going through all of the outfit images and deleting the ones user decided to delete
        if (imagesToDelete.containsKey(outfitItemID.trim())) {
          print("deleting: $outfitItemID");
          await FirebaseStorage.instance.ref(outfitItem.fullPath).delete();
        }
      }
      return 0;
    } catch (e) {
      return 1;
    }
  }
}
