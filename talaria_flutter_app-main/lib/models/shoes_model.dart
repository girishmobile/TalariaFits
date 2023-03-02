import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:talaria/models/rating.dart';
import 'package:talaria/provider/dashboard_provider.dart';

class ShoesDataModel {
  Timestamp? createdAt;
  int? genderType; //0 == male, 1 == female, 2 == both
  Map<String, List<String>>? images = {};
  //double? price;
  String? mainImage = "";
  List<double>? size;
  String? name;
  String? id;
  String? description;
  String? brand;
  DocumentReference? reference;
  List<ShoeRatingModel> shoesRating = [];
  Map<String, String>? outfitsImages;

  @override
  String toString() {
    return 'ShoesDataModel{genderType: $genderType, images: $images, mainImage: $mainImage, size: $size, name: $name, id: $id, description: $description, brand: $brand, shoesRating: $shoesRating, outfitsImages: $outfitsImages}';
  } //List<String>? outFitsImagesUrl;

  ShoesDataModel(
      {this.genderType,
      this.images,
      this.mainImage,
      //this.price,
      this.reference,
      //this.outFitsImagesUrl,
      this.size,
      this.name,
      this.id,
      this.description,
      this.brand,
      this.createdAt,
      this.outfitsImages});

  ShoesDataModel.fromJson(dynamic json, DocumentReference documentReference) {
    reference = documentReference;
    genderType = json['gender_type'];

    if (json['images'] != null) {
      var tempImages = json['images'] as Map<String, dynamic>;
      for (var entry in tempImages.entries) {
        images!.putIfAbsent(entry.key, () => (entry.value.cast<String>()));
      }
    }
    mainImage = json['main_image'];
    //price = json['price'];
    size = json['Size'] != null ? json['Size'].cast<double>() : [];
    name = json['name'];
    description = json['description'];
    brand = json['brand'];
    id = json['id'];

    if (json['created_at'] != null) {
      // createdAt = json['created_at'];

      // Added myTimestamp function for checking
      Timestamp? acceptedAt = myTimestamp(json['created_at']);
      if (acceptedAt != null) {
        createdAt = acceptedAt;
      }
    }
    outfitsImages = (json['outfits_images'] == null)
        ? {}
        : json['outfits_images'].cast<String, String>();
    getShoesReviews();
  }
  //******************************/
  //GIRISH CHAUHAN :- 15-FEB-2023
  //******************************/
  Timestamp? myTimestamp(dynamic dateValue) {
    if (dateValue is DateTime) {
      return Timestamp.fromDate(dateValue);
    } else if (dateValue is String) {
      return Timestamp.fromDate(DateTime.parse(dateValue));
    } else if (dateValue is Timestamp) {
      return dateValue;
    } else if (dateValue is Map) {
      Timestamp ts = Timestamp(
          (dateValue['_seconds'] as int), (dateValue['_nanoseconds'] as int));
      return ts;
    } else {
      return null;
    }
  }

  ShoesDataModel.fromJson2(dynamic json) {
    genderType = json['gender_type'];
    if (json['images'] != null) {
      var tempImages = json['images'] as Map<String, dynamic>;
      for (var entry in tempImages.entries) {
        images!.putIfAbsent(entry.key, () => (entry.value.cast<String>()));
      }
    }
    mainImage = json['main_image'];
    //price = json['price'];
    // outFitsImagesUrl = json['out_fits_images_url'] != null
    //     ? json['out_fits_images_url'].cast<String>()
    //     : [];
    size = json['Size'] != null ? json['Size'].cast<double>() : [];
    name = json['name'];
    description = json['description'];
    brand = json['brand'];
    id = json['id'];
    createdAt = json['created_at'];
    outfitsImages = json['outfits_images'] ?? {};
    getShoesReviews();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['gender_type'] = genderType;
    if (images != null) {
      map['images'] = images;
    }
    map['main_image'] = mainImage;
    //map['price'] = price;
    map['Size'] = size;
    map['name'] = name;
    map['description'] = description;
    map['brand'] = brand;
    map['created_at'] = createdAt;
    //map['out_fits_images_url'] = outFitsImagesUrl;
    map['id'] = id;
    map['outfitsImages'] = outfitsImages ?? {};
    return map;
  }

  Future<void> getShoesReviews() async {
    QuerySnapshot<Map<String, dynamic>>? snapshot =
        await reference?.collection("ratings").get();
    if (snapshot != null && snapshot.docs.isNotEmpty) {
      snapshot.docs.forEach((element) {
        shoesRating.add(ShoeRatingModel.fromJson(element.data()));
      });
      Provider.of<DashboardProvider>(Get.context!, listen: false).update();
    } else {
      shoesRating = [];
    }
  }

  double get shoesRatingValue {
    double value = shoesRating.fold(
        0, (double value, element) => value += element.rating!);
    if (value == 0 || shoesRating.isEmpty) return 0;
    return value / shoesRating.length;
  }
}
