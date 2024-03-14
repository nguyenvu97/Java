import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

@JsonSerializable()
class ProductADD {
  final double price;
  final String productName;
  final int quantity;
  final String category;
  // final String img; // Use String for image URL

  ProductADD(
      {required this.price,
      required this.productName,
      required this.quantity,
      required this.category
      // required this.img,
      });

  // Convert the object to a human-readable string
  @override
  String toString() {
    return 'ProductADD{price: $price, productName: $productName, quantity: $quantity,category:$category}';
  }

  // Convert the object to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'productName': productName,
      'quantity': quantity,
      'category': category
    };
  }

  // Create a ProductADD instance from a JSON object
  factory ProductADD.fromJson(Map<String, dynamic> json) {
    return ProductADD(
        price: json['price'] as double,
        productName: json['productName'] as String,
        quantity: json['quantity'] as int,
        category: json['category'] as String);
  }
}
