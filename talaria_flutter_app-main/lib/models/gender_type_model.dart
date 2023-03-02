import 'package:cloud_firestore/cloud_firestore.dart';

class GenderTypeModel {
  String? name;
  Timestamp? createdAt;

  GenderTypeModel({
    this.name,
    this.createdAt,
  });

  GenderTypeModel.fromJson(dynamic json) {
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
    return 'GenderTypeModel{name: $name, createdAt: $createdAt}';
  }
}
