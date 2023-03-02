import 'package:http/http.dart' as http;
import 'dart:convert';

class SneakersService {
  Future<dynamic> getSneakersByBrand(String brandName) async {
    try {
      final httpResponse = await http.get(
          Uri.parse(
              "https://the-sneaker-database.p.rapidapi.com/sneakers?limit=100"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-RapidAPI-Host': 'the-sneaker-database.p.rapidapi.com',
            'X-RapidAPI-Key':
                '7b6057ada7mshb46331d69040847p1df75ejsn45a72229d848'
          });
      if (httpResponse.statusCode == 200) {
        var decodedBody =
            json.decode(httpResponse.body)['results'] as List<dynamic>;
        return decodedBody;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> searchSneakersByQuery(
      {required String query, required int page}) async {
    try {
      final httpResponse = await http.get(
          Uri.parse(
              "https://the-sneaker-database.p.rapidapi.com/search?limit=100&query=$query&page=$page"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-RapidAPI-Host': 'the-sneaker-database.p.rapidapi.com',
            'X-RapidAPI-Key':
                '7b6057ada7mshb46331d69040847p1df75ejsn45a72229d848'
          });
      if (httpResponse.statusCode == 200) {
        var decodedBody =
            json.decode(httpResponse.body)['results'] as List<dynamic>;
        return decodedBody;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
