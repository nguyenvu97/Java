import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thaidui/Service/HomeService/HomeService.dart';
import 'package:thaidui/Service/HomeService/MemberData.dart';
import 'package:thaidui/Service/Order_Details/OrderModel.dart';
import 'package:thaidui/Service/Order_Details/Order_Details.dart';
import 'package:http/http.dart' as http;
import 'package:thaidui/Service/Recharge/RechargeDto.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsService {
  /**
   * createOrderdetails OK
   * PaymentVnPay OK
   * PayAmount
   */

  final storage = FlutterSecureStorage();
  Future<List<OrderItem>?> createOrderdetails(
      List<int> productIds, OrderModel orderItem, String? discount) async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }
    if (discount != null) {
      try {
        final response = await http.post(
          Uri.parse(
              'http://localhost:9091/api/v1/orderDetails?products=${productIds.join(',')}&discount=$discount'),
          headers: {
            'Authorization': '$token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'quantity': orderItem.quantities,
            'shipMoney': orderItem.shipMoney,
            'phone': orderItem.phone,
            'address': orderItem.address,
          }),
        );
        print(discount.runtimeType);
        print('quantity: ${orderItem.quantities}');
        print('shipMoney: ${orderItem.shipMoney}');
        print(response.body);

        if (response.statusCode == 200) {
          List<dynamic> dataList = jsonDecode(response.body);
          List<OrderItem> orderItems = [];

          for (var data in dataList) {
            OrderItem orderItem = OrderItem.fromJson(data);
            orderItems.add(orderItem);

            // In thông tin Order từ OrderItem
            Order order = orderItem.order!;
            print(
                'Order ID: ${order.id}, Order No: ${order.orderNo}, Payment: ${order.payment}');
            // storage.write(key: 'orderNo', value: order.orderNo)

            // PaymentVnPay(order.orderNo!);
          }

          return orderItems;
        } else {
          print("Error: ${response.statusCode}");
        }
      } catch (e) {
        print("System error: $e");
      }

      return null;
    }
    print("discount == null");
  }

  Future<void> _launchUrl(String url) async {
    Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }

    // handlePaymentSuccess();
  }
  /**
   * PaymentVnPay
   */

  Future<RechargeDto?> PaymentVnPay(String? OrderNo) async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }
    try {
      final response = await http.get(
          Uri.parse('http://localhost:9091/api/vnpay/payUser?orderNo=$OrderNo'),
          headers: {
            'Authorization': '$token',
            'Content-Type': 'application/json',
          });
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponseMap = json.decode(response.body);
        if (jsonResponseMap['status'] != null) {
          RechargeDto data = RechargeDto.fromJson(jsonResponseMap);

          print(response.body);

          // Xử lý phản hồi thành công
          print('Recharge successful');
          _launchUrl(data.url);

          return data;
        } else {
          print('Invalid JSON response');
        }
      } else {
        // Xử lý lỗi
        print('Failed to recharge. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("System error: $e");
    }

    // Trả về null nếu có lỗi
    return null;
  }

/**
 * PayAmount
 */
  Future<String?> PayAmount(String orderNo) async {
    String? token = await storage.read(key: 'access_token');
    if (token == null && orderNo == '') {
      return null;
    }
    try {
      final response = await http.post(
          Uri.parse(
              'http://localhost:9091/api/v1/orderDetails/payAmount?orderNo=$orderNo'),
          headers: {
            'Authorization': '$token',
            'Content-Type': 'application/json',
          });

      if (response.statusCode == 200) {
        return "payment OK";
      }
      return "pay Amount Not Ok";
    } catch (e) {
      print("loi he thong $e");
    }
  }

  /*
  countOrderSUCCESS
   */
  Future<int?> countOrderSUCCESS() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }
    try {
      final response = await http.get(
          Uri.parse(
              'http://localhost:9091/api/v1/orderDetails/countOrderSUCCESS'),
          headers: {
            'Authorization': '$token',
          });
      if (response.statusCode == 200) {
        return int.parse(response.body);
      }
      print("loi countOrderSUCCESS");
    } catch (e) {
      print("loi he thong countOrderSUCCESS $e ");
    }
  }

  /*
  countOrderFAIL
   */
  Future<int?> countOrderFAIL() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }
    try {
      final response = await http.get(
          Uri.parse('http://localhost:9091/api/v1/orderDetails/countOrderFAIL'),
          headers: {
            'Authorization': '$token',
          });
      if (response.statusCode == 200) {
        return int.parse(response.body);
      }
      print("loi countOrderSUCCESS");
    } catch (e) {
      print("loi he thong countOrderSUCCESS $e ");
    }
  }

  /*
  countOrderREFUND
   */
  Future<int?> countOrderREFUND() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }
    try {
      final response = await http.get(
          Uri.parse(
              'http://localhost:9091/api/v1/orderDetails/countOrderREFUND'),
          headers: {
            'Authorization': '$token',
          });
      if (response.statusCode == 200) {
        return int.parse(response.body);
      }
      print("loi countOrderSUCCESS");
    } catch (e) {
      print("loi he thong countOrderSUCCESS $e ");
    }
  }

  /*
  countOrderUNPAID
   */
  Future<int?> countOrderUNPAID() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return null;
    }
    try {
      final response = await http.get(
          Uri.parse(
              'http://localhost:9091/api/v1/orderDetails/countOrderUNPAID'),
          headers: {
            'Authorization': '$token',
          });
      if (response.statusCode == 200) {
        return int.parse(response.body);
      }
      print("loi countOrderSUCCESS");
    } catch (e) {
      print("loi he thong countOrderSUCCESS $e ");
    }
  }
}
