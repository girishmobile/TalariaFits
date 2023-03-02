import 'dart:convert';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

APISneakerModel sneakerModelFromMap(String str) =>
    APISneakerModel.fromMap(json.decode(str));

String sneakerModelToMap(APISneakerModel data) => json.encode(data.toMap());

class APISneakerModel {
  APISneakerModel({
    required this.id,
    required this.sku,
    required this.brand,
    required this.name,
    required this.colorway,
    required this.gender,
    required this.silhouette,
    required this.releaseYear,
    required this.releaseDate,
    required this.retailPrice,
    required this.estimatedMarketValue,
    required this.story,
    required this.image,
    required this.links,
  });

  String id;
  String sku;
  String brand;
  String name;
  String colorway;
  String gender;
  String silhouette;
  String releaseYear;
  DateTime releaseDate;
  int retailPrice;
  int estimatedMarketValue;
  String story;
  Image image;
  Links links;

  factory APISneakerModel.fromMap(Map<String, dynamic> json) {
    String parsedStory = "";
    for (int i = 0; i < json['story'].length; i++) {
      if (json['story'][i].codeUnitAt(0) >= 32 &&
          json['story'][i].codeUnitAt(0) <= 126) {
        parsedStory += json['story'][i];
      }
    }
    DateTime releaseDate;
    try {
      releaseDate = DateTime.parse(json["releaseDate"]);
    } catch (e) {
      releaseDate = DateTime.now();
    }
    return APISneakerModel(
      id: json["id"],
      sku: json["sku"],
      brand: json["brand"],
      name: json["name"],
      colorway: json["colorway"],
      gender: "${toBeginningOfSentenceCase(json["gender"])}",
      silhouette: json["silhouette"],
      releaseYear: json["releaseYear"],
      releaseDate: releaseDate,
      retailPrice: json["retailPrice"],
      estimatedMarketValue: json["estimatedMarketValue"],
      story: parsedStory,
      image: Image.fromMap(json["image"]),
      links: Links.fromMap(json["links"]),
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "sku": sku,
        "brand": brand,
        "name": name,
        "colorway": colorway,
        "gender": gender,
        "silhouette": silhouette,
        "releaseYear": releaseYear,
        "releaseDate":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "retailPrice": retailPrice,
        "estimatedMarketValue": estimatedMarketValue,
        "story": story,
        "image": image.toMap(),
        "links": links.toMap(),
      };

  @override
  String toString() {
    return 'APISneakerModel{id: $id, sku: $sku, brand: $brand, name: $name, colorway: $colorway, gender: $gender, silhouette: $silhouette, releaseYear: $releaseYear, releaseDate: $releaseDate, retailPrice: $retailPrice, estimatedMarketValue: $estimatedMarketValue, story: $story, image: $image, links: $links}';
  }
}

class Image {
  Image({
    required this.the360,
    required this.original,
    required this.small,
    required this.thumbnail,
  });

  List<dynamic> the360;
  String original;
  String small;
  String thumbnail;

  factory Image.fromMap(Map<String, dynamic> json) => Image(
        the360: List<dynamic>.from(json["360"].map((x) => x)),
        original: json["original"],
        small: json["small"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toMap() => {
        "360": List<dynamic>.from(the360.map((x) => x)),
        "original": original,
        "small": small,
        "thumbnail": thumbnail,
      };

  @override
  String toString() {
    return 'Image{the360: $the360, original: $original, small: $small, thumbnail: $thumbnail}';
  }
}

class Links {
  Links({
    required this.stockX,
    required this.goat,
    required this.flightClub,
    required this.stadiumGoods,
  });

  String stockX;
  String goat;
  String flightClub;
  String stadiumGoods;

  factory Links.fromMap(Map<String, dynamic> json) => Links(
        stockX: json["stockX"],
        goat: json["goat"],
        flightClub: json["flightClub"],
        stadiumGoods: json["stadiumGoods"],
      );

  Map<String, dynamic> toMap() => {
        "stockX": stockX,
        "goat": goat,
        "flightClub": flightClub,
        "stadiumGoods": stadiumGoods,
      };

  @override
  String toString() {
    return 'Links{stockX: $stockX, goat: $goat, flightClub: $flightClub, stadiumGoods: $stadiumGoods}';
  }
}
