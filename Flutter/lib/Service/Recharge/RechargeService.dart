import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:thaidui/Service/Recharge/RechargeDto.dart';

class RechargeServcie {
  final storage = FlutterSecureStorage();
  //  OK

  Future<RechargeDto?> rechargeUser(int money) async {
    String? token = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
        Uri.parse('http://localhost:9091/api/vnpay/recharge?amountUser=$money'),
        headers: {'Authorization': '$token'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponseMap = json.decode(response.body);

        // Kiểm tra nếu jsonResponseMap['status'] không phải là null
        if (jsonResponseMap['status'] != null) {
          RechargeDto data = RechargeDto.fromJson(jsonResponseMap);

          print(response.body);

          // Xử lý phản hồi thành công
          print('Recharge successful');

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

  // Future<RechargeDto?> dominRecharge() async {
  //   try {
  //     final respones = await http
  //         .get(Uri.parse('http://localhost:9091/api/vnpay/recharge123'));
  //     if (respones.statusCode == 200) {
  //       Map<String, dynamic> jsonResponseMap = json.decode(respones.body);
  //       if (jsonResponseMap['status'] == 'ok') {
  //         RechargeDto data = RechargeDto.fromJson(jsonResponseMap);
  //         return data;
  //       } else {
  //         print('Invalid JSON response');
  //       }
  //     }
  //   } catch (e) {
  //     print("lo he thong $e");
  //   }
  // }
}
