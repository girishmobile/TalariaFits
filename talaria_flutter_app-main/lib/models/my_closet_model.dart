import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talaria/models/shoes_model.dart';

class MyClosetModel {
  double? selectedSize;
  Timestamp? createdAt;
  String? shoesId;
  ShoesDataModel? shoesDataModel;

  // ColorData? selectedColor;

  MyClosetModel({
    this.selectedSize,
    this.createdAt,
    this.shoesId,
    this.shoesDataModel,
    // this.selectedColor,
  });

  MyClosetModel.fromJson(dynamic json) {
    selectedSize = json['selected_size'];
    createdAt = json['created_at'];
    shoesId = json['shoes_id'];
    shoesDataModel = ShoesDataModel.fromJson2(
      json["shoes_detail"],
    );
    // selectedColor = ColorData.fromJson(json['selected_color']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['selected_size'] = selectedSize;
    map['created_at'] = createdAt;
    map['shoes_id'] = shoesId;
    map["shoes_detail"] = shoesDataModel?.toJson();
    // map['selected_color'] = selectedColor?.toJson();
    return map;
  }
}
