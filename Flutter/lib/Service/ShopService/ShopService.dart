import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thaidui/Myshop/SeeShop.dart';
import 'package:thaidui/Service/Order_Details/Order_details.dart';
import 'package:thaidui/Service/ProductService/ProductEntity.dart';
import 'package:thaidui/Service/ProductService/ProductService.dart';
import 'package:thaidui/Service/ShopService/ProductAdd.dart';
import 'package:thaidui/Service/ShopService/Shop.dart';
import 'package:http/http.dart' as http;

class ShopService {
  final storage = FlutterSecureStorage();

  final ProductService productService = ProductService();
  /* 
 1)Open Shop     OK
 2)Add Product Shop     OK 
 3)Update Product shop for ProductID  Ok
4)findByProductIdForStore  Ok
5)paymentShop
6) top3 new product in store  Ok
7) countCategory ok
  */
  Future<Store?> OpenShop() async {
    String? token = await storage.read(key: 'access_token');
    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('http://localhost:9091/api/v1/store/create'),
          headers: {'Authorization': '$token'},
        );

        if (response.statusCode == 201) {
          Map<String, dynamic> data = jsonDecode(response.body);
          Store store = Store.fromJson(data);
          print(store);
          return store;
        } else {
          // Xử lý lỗi khi gọi API
          print('Lỗi khi gọi API: ${response.statusCode}');
        }
      } catch (e) {
        // Xử lý lỗi trong quá trình gọi API
        print('Lỗi khi gọi API: $e');
      }
    }
    return null;
  }

/* 
 2)Add Product Shop 
 
  */

  Future<String?> addProduct(
      String token, ProductADD productJson, File image) async {
    try {
      var request = http.MultipartRequest(
        'post',
        Uri.parse('http://localhost:9091/api/v1/product/save'),
      );

      // Add headers
      request.headers['Authorization'] = '$token';

      // Add product JSON
      request.fields['product'] = jsonEncode(productJson.toJson());

      // Add image file
      var imageStream = http.ByteStream(image.openRead());
      var imageLength = await image.length();
      var multipartFile = http.MultipartFile(
        'image',
        imageStream,
        imageLength,
        filename: 'product_image.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      // Send request
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print(responseBody);

        if (responseBody.isNotEmpty) {
          return "save ok";
        } else {
          return "Failed to add product";
        }
      } else {
        return "Failed to add product. Status code: ${response.statusCode}";
      }
    } catch (e) {
      print("System error: $e");
    }
  }

  /*

   3)Update Product shop for ProductID

   */
  Future<ProductADD?> updateProductForShop(
      int productId, ProductADD product) async {
    String? token = await storage.read(key: 'access_token');
    if (token != null) {
      try {
        final response = await http.put(
          Uri.parse('http://localhost:9091/api/v1/product/store/$productId'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(product.toJson()),
        );

        if (response.statusCode == 200) {
          // Xử lý dữ liệu thành công
          final decodedData = json.decode(response.body);
          ProductADD updatedProduct = ProductADD.fromJson(decodedData);
          return updatedProduct;
        } else {
          // Xử lý lỗi khi gọi API
          print('Lỗi khi gọi API: ${response.statusCode}');
        }
      } catch (e) {
        // Xử lý lỗi trong quá trình gọi API
        print('Lỗi khi gọi API: $e');
      }
    }
    return null;
  }

  /*
  4) findByProductIdForStore
   */
  Future<List<ProductEntity>?> getAllProductForStore() async {
    String? token = await storage.read(key: 'access_token');
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://localhost:9091/api/v1/store/storeId'),
          headers: {'Authorization': '$token'},
        );

        if (response.statusCode == 200) {
          // Xử lý dữ liệu thành công
          List<dynamic> data = json.decode(response.body);
          List<ProductEntity> products =
              data.map((json) => ProductEntity.fromJson(json)).toList();

          print(products);
          return products;
        } else {
          // Xử lý lỗi khi gọi API
          print('Lỗi khi gọi API: ${response.statusCode}');
        }
      } catch (e) {
        // Xử lý lỗi trong quá trình gọi API
        print('Lỗi khi gọi API: $e');
      }
    }
  }

  /**
   * top3 new product in store 
   */
  Future<List<ProductEntity>?> top3NewProductInStore() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }
    try {
      final response = await http.get(
        Uri.parse('http://localhost:9091/api/v1/store/top3Product'),
        headers: {'Authorization': '$token'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<ProductEntity> products =
            data.map((json) => ProductEntity.fromJson(json)).toList();
        print(products);
        return products;
      }
      print('loi me roi top 3 product');
    } catch (e) {
      print("loi top 3 san pahm $e");
    }
  }

  /**
   * countCategory
   */
  Future<List<ProductEntity>?> countCategory(String category) async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:9091/api/v1/store/countCategory?category=$category'),
        headers: {'Authorization': '$token'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<ProductEntity> products =
            data.map((json) => ProductEntity.fromJson(json)).toList();
        print(products);
        return products;
      }
      print('loi me roi top 3 product');
    } catch (e) {
      print("loi top 3 san pahm $e");
    }
  }

  Future<List<OrderItem>?> getHistoryShopOk() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('http://localhost:9091/api/v1/orderDetails/HistoryShopBuyOk'),
        headers: {'Authorization': '$token'},
      );

      if (response.statusCode == 200) {
        print(response.body);
        List<dynamic> data = jsonDecode(response.body);
        List<OrderItem> orders =
            data.map((item) => OrderItem.fromJson(item)).toList();
        print(orders);
        return orders;
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("System error: $e");
    }

    return null;
  }

  Future<String?> updateShop(Store store, File image) async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }
    try {
      final request = await http.MultipartRequest(
        'post',
        Uri.parse('http://localhost:9091/api/v1/store/updateStore'),
      );
      request.headers['Authorization'] = '$token';
      request.fields['store'] = jsonEncode(store.toJson());
      var imageStream = http.ByteStream(image.openRead());
      var imageLength = await image.length();
      var multipartFile = http.MultipartFile(
        'image',
        imageStream,
        imageLength,
        filename: 'product_image.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      // Send request
      var response = await request.send();
      if (response.statusCode == 201) {
        String responseBody = await response.stream.bytesToString();
        print(responseBody);

        if (responseBody.isNotEmpty) {
          return "save Ok";
        } else {
          print("loi isNotEmpty");
          return null;
        }
      }
      print("loi he thong updateShop");
    } catch (e) {
      print("loi he thing updateShop $e");
    }
  }

  Future<String?> updateImage(File image) async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }
    try {
      final request = await http.MultipartRequest(
          'post', Uri.parse('http://localhost:9091/api/v1/store/chageImage'));
      request.headers['Authorization'] = '$token';
      var imageStream = http.ByteStream(image.openRead());
      var imageLength = await image.length();
      var multipartFile = http.MultipartFile(
        'image',
        imageStream,
        imageLength,
        filename: 'product_image.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);
      final response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        if (responseBody.isEmpty) {
          return "save Ok";
        }
        return "save not ok";
      }
    } catch (e) {
      print("loi he thing updateImage $e");
    }
  }
}
