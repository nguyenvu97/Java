import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:thaidui/NotFound/NotFound.dart';
import 'package:thaidui/Service/HomeService/MemberData.dart';

class HomeService {
  //  OK
  final storage = FlutterSecureStorage();
  Future<MemberData?> DecodeToken() async {
    String? token = await storage.read(key: 'access_token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://localhost:9091/api/v1/decode'),
          headers: {'Authorization': '$token'},
        );

        if (response.statusCode == 200) {
          // Xử lý dữ liệu thành công
          final decodedData = json.decode(response.body);
          MemberData memberData = MemberData.fromJson(decodedData);
          print(memberData);
          return memberData;
        } else {
          // Xử lý lỗi khi gọi API
          print('Lỗi khi gọi API: ');
        }
      } catch (e) {
        // Xử lý lỗi trong quá trình gọi API
        print('Lỗi khi gọi API: $e');
      }
    }
    return null;
  }
}
