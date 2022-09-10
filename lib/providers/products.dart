import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [
    /*
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere(((prod) => prod.id == id));
  }

  Future<void> fetchProducts() async {
    final Uri url = Uri.parse(
        "https://shopappacademind-a96ee-default-rtdb.europe-west1.firebasedatabase.app/products.json");
    try {
      final http.Response response = await http.get(
        url,
      );
      final List<Product> fetchedData = [];
      //_items = json.decode(response.body);
      final Map<String, dynamic> decoded = json.decode(response.body);
      decoded.forEach((prodId, prodData) {
        fetchedData.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite']));
      });
      _items = fetchedData;
      notifyListeners();
      //Product product = Product(id: response.body, title: title, description: description, price: price, imageUrl: imageUrl)
    } catch (error) {
      null;
    }
  }

  Future<void> addProduct(Product product) async {
    final Uri url = Uri.parse(
        "https://shopappacademind-a96ee-default-rtdb.europe-west1.firebasedatabase.app/products.json");
    try {
      final http.Response response = await http.post(url,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "isFavorite": product.isFavorite
          }));
      final Product productData = Product(
        id: json.decode(response.body)['name'] as String,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(productData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    /*
        .then((response) {
     
    }).catchError((error) {
      return error;
    }).then((value) => null);*/
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final Uri url = Uri.parse(
          "https://shopappacademind-a96ee-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json");
      try {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
            }));
        _items[prodIndex] = newProduct;
      } catch (e) {
        null;
      }
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final Uri url = Uri.parse(
        "https://shopappacademind-a96ee-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json");
    final int existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    final Product existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final http.Response response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw const HttpException('Could not delete product');
    }
    existingProduct.dispose();
  }
}
