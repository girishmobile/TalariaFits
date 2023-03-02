import 'package:cloud_firestore/cloud_firestore.dart';

class BrandsModel {
  String? name;
  Timestamp? createdAt;

  BrandsModel({
    this.name,
    this.createdAt,
  });

  BrandsModel.fromJson(dynamic json) {
    name = json['name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['created_at'] = createdAt;
    return map;
  }

  @override
  String toString() {
    return 'BrandsModel{name: $name, createdAt: $createdAt}';
  }
}
