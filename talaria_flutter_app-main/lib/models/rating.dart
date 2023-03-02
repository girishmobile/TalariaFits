import 'package:cloud_firestore/cloud_firestore.dart';

class ShoeRatingModel {
  double? rating;
  String? message;
  String? userId;
  Timestamp? createdAt;

  ShoeRatingModel({this.rating, this.message, this.userId, this.createdAt});

  ShoeRatingModel.fromJson(Map<String, dynamic> json)
      : rating = json['rating'],
        message = json['message'],
        createdAt = json['created_at'],
        userId = json['user_id'];

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'created_at': createdAt,
        'message': message,
        'user_id': userId,
      };
}
