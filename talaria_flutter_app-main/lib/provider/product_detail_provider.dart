import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../models/shoes_model.dart';

class ProductDetailProvider with ChangeNotifier {
  double rating = 5;
  int? selectedShoeSize;
  int? selectedShoeSizeIndex;
  ShoesDataModel? shoeModel;
  void updateRating(double newRating) {
    rating = newRating;
    notifyListeners();
  }

  void updateSelectedShoeSize(
      {required int newShoeSize, required int newShoeSizeIndex}) {
    selectedShoeSize = newShoeSize;
    selectedShoeSizeIndex = newShoeSizeIndex;
    notifyListeners();
  }

  void generateShoeColorImageWidgets() {
    List<CachedNetworkImage> images = [];
    //ColorData colorData = shoeModel!.color!;
    //  for (String imageURL in colorData.sliderImagesUrl) {

    // }
  }
}
