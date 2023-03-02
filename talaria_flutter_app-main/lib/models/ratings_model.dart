class RatingsModel {
  double? rating;
  String? message;

  RatingsModel({
      this.rating, 
      this.message,});

  RatingsModel.fromJson(dynamic json) {
    rating = json['rating'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rating'] = rating;
    map['message'] = message;
    return map;
  }

}