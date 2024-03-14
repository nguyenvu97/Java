import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:thaidui/Service/ProductService/ProductEntity.dart';

class ProductService {
  /*
  1)searchProduct OK
  2)getAllProduct OK 
  3)getByProductId OK
  4)uploadImage OK
   */
  Future<List<ProductEntity>> searchProduct(String keyword) async {
    final response = await http.get(Uri.parse(
        'http://localhost:9091/api/v1/product/sreachProduct?keyword=$keyword'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<ProductEntity> products =
          data.map((json) => ProductEntity.fromJson(json)).toList();
      print(products);
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<ProductEntity>> getAllProduct() async {
    final response = await http
        .get(Uri.parse('http://localhost:9091/api/v1/product/GetallProduct'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<ProductEntity> products =
          data.map((json) => ProductEntity.fromJson(json)).toList();
      print(products);
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<ProductEntity?> getByProductId(int id) async {
    final response = await http.get(
        Uri.parse('http://localhost:9091/api/v1/product/GetByProductId/$id'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      ProductEntity product = ProductEntity.fromJson(data);
      print(product);
      return product;
    }
    return null;
  }

  Future<String> uploadImage(String fileName) async {
    final response = await http.get(
        Uri.parse('http://localhost:9091/api/v1/product/fileSystem/$fileName'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load image: $fileName');
    }
  }
}
