import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:thaidui/Service/DisCount/DisCount.dart';

class DisCountService {
  Future<List<Discount>?> getAllDiscount() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:9091/api/v1/discounts/all'),
        // Đặt các headers cần thiết tại đây (nếu có)
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        print(response.body);
        List<Discount> discounts =
            data.map((json) => Discount.fromJson(json)).toList();
        print("discounts $discounts");
        return discounts;
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print("System error: $e");
      return null;
    }
  }
}
