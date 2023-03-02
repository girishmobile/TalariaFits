import 'package:flutter/cupertino.dart';

import '../models/shoes_model.dart';

class SearchProvider with ChangeNotifier {
  List<ShoesDataModel> searchListToDisplay = [];
  List<ShoesDataModel> originalListToDisplay = [];

  void updateSearchList(String searchQuery) {
    searchListToDisplay = [];
    notifyListeners();
    searchQuery = searchQuery.toLowerCase().trim();
    if (searchQuery.isEmpty) {
      searchListToDisplay = originalListToDisplay;
      notifyListeners();
      return;
    }
    for (ShoesDataModel shoesDataModel in originalListToDisplay) {
      if (shoesDataModel.name!.toLowerCase().contains(searchQuery) ||
          shoesDataModel.brand!.toLowerCase().contains(searchQuery)) {
        searchListToDisplay.add(shoesDataModel);
        notifyListeners();
      }
    }
  }

  void initializeSearchList() {
    searchListToDisplay = originalListToDisplay;
    notifyListeners();
  }

  void fillOriginalShoesList(List<ShoesDataModel> originalList) {
    originalListToDisplay = originalList;
    notifyListeners();
  }

  void removeShoeFromSearchListToDisplay(ShoesDataModel shoesDataModel) {
    searchListToDisplay.remove(shoesDataModel);
    notifyListeners();
  }

  void removeShoeFromOriginalListToDisplay(ShoesDataModel shoesDataModel) {
    originalListToDisplay.remove(shoesDataModel);
    notifyListeners();
  }

  ///this function updates the shoe data inside searchListToDisplay and originalListToDisplay
  ///it is used inside AddOutfitsProvider
  void updateShoesOutfitImages({
    required String shoeID,
    required Map<String, String> outfitImages,
  }) {
    for (var shoe in originalListToDisplay) {
      if (shoe.id! == shoeID) {
        shoe.outfitsImages = outfitImages;
        break;
      }
    }
    for (var shoe in searchListToDisplay) {
      if (shoe.id! == shoeID) {
        shoe.outfitsImages = outfitImages;
        break;
      }
    }
    notifyListeners();
  }
}
