import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:thaidui/Service/Refound/Order_Refound.dart';

class OrderRefoudService {
  final storage = FlutterSecureStorage();
  /**
   * orderRefoudProduct
   * GetAllHistoryOrderRefoud
   */

  Future<String?> orderRefoudProduct(
      String orderNo, int productId, String reason) async {
    String? token = await storage.read(key: 'access_token');
    try {
      final responst = await http.post(
          Uri.parse(
              'http://localhost:9091/api/v1/OrderRefund?orderNo=$orderNo&productId=$productId&reason=$reason'),
          headers: {'Authorization': '$token'});
      if (responst.statusCode == 200) {
        print(responst.body);
        return "delete Ok";
      }
      return "delete not ok";
    } catch (e) {
      print("loi he thong refoud $e");
    }
  }

  Future<List<Order_Refound>?> GetAllHistoryOrderRefoud() async {
    String? token = await storage.read(key: 'access_token');
    try {
      final response = await http.get(
          Uri.parse('http://localhost:9091/api/v1/OrderRefund/listOrderRefund'),
          headers: {'Authorization': '$token'});
      if (response.statusCode == 200) {
        print(response.body);
        List<dynamic> dataList = jsonDecode(response.body);
        List<Order_Refound> listOrderRefound = [];
        for (var data in dataList) {
          Order_Refound order_refound = Order_Refound.fromJson(data);
          listOrderRefound.add(order_refound);
          print(order_refound);
        }
        return listOrderRefound;
      }
      print("loi me roi ${response.body}");
    } catch (e) {
      print("loi he thong Order_Refound  $e ");
    }
  }
}
