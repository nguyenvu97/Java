import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:thaidui/Service/UserService/User.dart';

class UserService {
  final storage = FlutterSecureStorage();
  Future<bool> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:9091/api/v1/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        // Xử lý thành công
        print('Đăng ký thành công');
        return true;
      } else {
        // Xử lý lỗi
        print('Đăng ký thất bại: ${response.body}');
        return false;
      }
    } catch (e) {
      // Xử lý lỗi
      print('Lỗi trong quá trình đăng ký: $e');
      return false;
    }
  }

  Future<bool> Login(String email, String password) async {
    final storage = new FlutterSecureStorage();
    try {
      final response =
          await http.post(Uri.parse('http://localhost:9091/api/v1/auth/login'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({
                'email': email,
                'password': password,
              }));
      if (response.statusCode == 200) {
        // Xử lý thành công
        print('Đăng nhập thành công');
        print(response.body);
        final Map<String, dynamic> data = json.decode(response.body);
        await storage.write(key: 'access_token', value: data['access_token']);
        await storage.write(key: 'refresh_token', value: data['refreshToken']);
        return true;
      } else {
        print('Đăng nhập thất bại: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Lỗi trong quá trình đăng ký: $e');
      return false;
    }
  }

  Future<void> logOut() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      return;
    }
    try {
      final response = await http.get(
          Uri.parse('http://localhost:9091/api/v1/auth/logout'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        storage.delete(key: 'access_token');
        storage.delete(key: 'refresh_token');
        print("logout Ok");
        return;
      }
      print('logout fail');
    } catch (e) {
      print("loi logout token + $e");
    }
  }

/* 
forGetpassword
*/
  Future<bool?> forGetpassword(String email) async {
    try {
      final response = await http.post(Uri.parse(
          'http://localhost:9091/api/v1/totp/createOtp?email=$email'));
      if (response.statusCode == 200) {
        print(response.body);
        return true;
      }
      print("not ok");
    } catch (e) {
      print("loi he thong forgetPassword $e");
    }
  }

  /* 
  inputOtpAndPassword
*/
  Future<String?> inputOtpAndPassword(int otp, String password) async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:9091/api/v1/totp/otp?otp=$otp&password=$password'));
      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      }
      print("not ok");
    } catch (e) {
      print("loi he thong forgetPassword $e");
    }
  }
}
