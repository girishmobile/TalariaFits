import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? fcm;
  String? profileImage;
  bool? isNotificationEnabled;
  bool? isEmailEnabled;
  bool? isBlocked;
  Timestamp? createdAt;
  String? lastName;
  String? phoneNumber;
  String? id;
  int? role; //1 == regular user; 2 == admin
  String? firstName;
  String? email;

  UserModel({
    this.fcm,
    this.profileImage,
    this.isNotificationEnabled,
    this.isEmailEnabled,
    this.createdAt,
    this.isBlocked,
    this.lastName,
    this.phoneNumber,
    this.role,
    this.id,
    this.firstName,
    this.email,
  });

  UserModel.fromJson(dynamic json) {
    fcm = json['fcm'];
    profileImage = json['profile_image'];
    isNotificationEnabled = json['is_notification_enabled'];
    isEmailEnabled = json['is_email_enabled'];
    isBlocked = json['is_blocked'];
    createdAt = json['created_at'];
    lastName = json['last_name'];
    role = json['role'];
    phoneNumber = json['phone_number'];
    id = json['id'];
    firstName = json['first_name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fcm'] = fcm;
    map['profile_image'] = profileImage;
    map['is_notification_enabled'] = isNotificationEnabled;
    map['is_email_enabled'] = isEmailEnabled;
    map['created_at'] = createdAt;
    map['last_name'] = lastName;
    map['is_blocked'] = isBlocked;
    map['role'] = role;
    map['phone_number'] = phoneNumber;
    map['id'] = id;
    map['first_name'] = firstName;
    map['email'] = email;
    return map;
  }

  @override
  String toString() {
    return 'UserModel{fcm: $fcm, profileImage: $profileImage, isNotificationEnabled: $isNotificationEnabled, isEmailEnabled: $isEmailEnabled, isBlocked: $isBlocked, createdAt: $createdAt, lastName: $lastName, phoneNumber: $phoneNumber, id: $id, role: $role, firstName: $firstName, email: $email}';
  }
}
