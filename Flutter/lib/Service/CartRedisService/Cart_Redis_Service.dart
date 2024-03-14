import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:thaidui/Service/CartRedisService/Cart.dart';

class CartRedisService {
/**
1) addCartRedis
2)getAllRedisCart
3)deleteProductCart
4)checkQuantity
 */

  final storage = FlutterSecureStorage();
  Future<Cart?> addCartRedis(int productID, int quantity) async {
    String? token = await storage.read(key: 'access_token');
    print(productID);
    if (token == null) {
      return null;
    }

    final response = await http.post(
      Uri.parse(
          'http://localhost:9091/api/v1/redisCart/addCartRedis?productId=$productID&quantity=$quantity'),
      headers: {'Authorization': '$token'},
    );
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      Cart cartFromServer = Cart.fromJson(decodedData);
      return cartFromServer;
    } else {
      // Xử lý lỗi khi gọi API
      print('Lỗi khi gọi API: ${response.statusCode}');
      return null;
    }
  }

  /*
   2)getAllRedisCart
   */
  Future<List<Cart>?> GetallCartRedis() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }
    try {
      final response = await http.get(
        Uri.parse('http://localhost:9091/api/v1/redisCart/getAllRedisCart'),
        headers: {'Authorization': '$token'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Cart> carts = data.map((json) => Cart.fromJson(json)).toList();
        print(carts);
        return carts;
      } else {
        // Xử lý lỗi khi gọi API
        print('Lỗi khi gọi API: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Xử lý lỗi trong quá trình gọi API
      print('Lỗi khi gọi API: $e');
      return null;
    }
  }
  /*
  3)deleteProductCart
   */

  Future<String> deleteProductCart(int productId) async {
    String? token = await storage.read(key: 'access_token');
    print(productId.runtimeType);
    print(productId);
    if (token != null) {
      try {
        final response = await http.delete(
          Uri.parse(
              'http://localhost:9091/api/v1/redisCart/deleteProductCart?productId=$productId'),
          headers: {
            'Authorization': '$token',
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          return response.body;
        } else {
          print('Lỗi khi gọi API: ${response.statusCode}');
          return "delete failed - ${response.statusCode}";
        }
      } catch (e) {
        print('Lỗi khi gọi API: $e');
      }
    }
    return 'delete failed - Token is null';
  }
  /*
  4)checkQuantity
   */

  Future<Cart?> UpdateQuantity(int productId, int newQuantity) async {
    String? token = await storage.read(key: 'access_token');
    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse(
              'http://localhost:9091/api/v1/redisCart/checkQuantity?productId=$productId&newQuantity=$newQuantity'),
          headers: {'Authorization': '$token'},
        );
        if (response.statusCode == 200) {
          final decodedData = json.decode(response.body);
          Cart cart = Cart.fromJson(decodedData);
          return cart;
        } else {
          print('Lỗi khi gọi API: ${response.statusCode}');
          return null;
        }
      } catch (e) {
        print('Lỗi khi gọi API: $e');
        return null;
      }
    }
  }
}
