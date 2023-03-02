import 'package:cloud_firestore/cloud_firestore.dart';

class MyFavouriteModel {
  Timestamp? createdAt;
  String? shoesId;
  String? status;

  MyFavouriteModel({
    this.createdAt,
    this.shoesId,
    this.status,
  });

  MyFavouriteModel.fromJson(dynamic json) {
    createdAt = json['created_at'];
    shoesId = json['shoes_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['created_at'] = createdAt;
    map['shoes_id'] = shoesId;
    map['status'] = status;
    return map;
  }
}
