import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app_academind/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavorite(String token, String userId) async {
    final bool oldStatus = isFavorite;
    isFavorite = !isFavorite;
    //notifyListeners();
    final Uri url = Uri.parse(
        "https://shopappacademind-a96ee-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token");
    try {
      final http.Response response =
          await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        const HttpException('Couldnt update');
        isFavorite = oldStatus;
      }
    } catch (e) {
      isFavorite = oldStatus;
    }
    notifyListeners();
  }
}
