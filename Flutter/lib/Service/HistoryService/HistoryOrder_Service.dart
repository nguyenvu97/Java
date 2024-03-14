import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thaidui/Service/Order_Details/Order_Details.dart';
import 'package:http/http.dart' as http;

class HistoryOrderService {
  /**
   * getHistory()
   * getHistoryOrderDetails
   * Order Not payment status auth
   * reachre Status Order == fail
   */
  final storage = FlutterSecureStorage();
  Future<List<Order>?> getHistory() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('http://localhost:9091/api/v1/orderDetails/historyOrder'),
        headers: {'Authorization': '$token'},
      );

      if (response.statusCode == 200) {
        print(response.body);
        List<dynamic> data = jsonDecode(response.body);
        List<Order> orders = data.map((item) => Order.fromJson(item)).toList();
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
  /**
   * 
   * getHistoryOrderDetails
   */

  Future<List<OrderItem>?> getHistoryOrderDetails(String orderNo) async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:9091/api/v1/orderDetails/historyOrderDetails?orderNo=$orderNo'),
        headers: {'Authorization': '$token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> dataList = jsonDecode(response.body);
        List<OrderItem> orderItems = [];

        for (var data in dataList) {
          OrderItem orderItem = OrderItem.fromJson(data);
          orderItems.add(orderItem);
          // In thông tin Order từ OrderItem
          Order order = orderItem.order!;
          print(response.body);
          Product product = orderItem.product!;
          print(product);
        }
        print(orderItems);
        return orderItems;
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("System error: $e");
    }

    return null;
  }

/**
 * 
 * Order Not payment status auth
 */
  Future<List<Order>?> listOrderAuth() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('http://localhost:9091/api/v1/orderDetails/historyOrderAuth'),
        headers: {'Authorization': '$token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Order> orders = data.map((item) => Order.fromJson(item)).toList();
        return orders;
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("System error: $e");
    }

    return null;
  }

/**
 * 
 * reachre Status Order == fail
 */
  Future<String?> ChangeStautus(String orderNo) async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }
    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:9091/api/v1/orderDetails/FailOrder?orderNo=$orderNo'),
        headers: {'Authorization': '$token'},
      );
      if (response.statusCode == 200) {
        print(response.body);
        print("ChangeStautus OK");
      } else {
        print("ChangeStautus not OK");
      }
    } catch (e) {
      print("loi he thong history $e");
    }
  }
}
