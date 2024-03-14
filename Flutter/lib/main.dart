import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thaidui/Cart/cart.dart';
import 'package:thaidui/CheckOut/CheckOut.dart';
import 'package:thaidui/History_Order_and_More/History_Order.dart';
import 'package:thaidui/Myshop/MyShop.dart';
import 'package:thaidui/Myshop/SeeShop.dart';
import 'package:thaidui/Myshop/ShopProduct/Finance_Shop.dart';
import 'package:thaidui/Myshop/ShopProduct/HistoryShop_BuyOk.dart';
import 'package:thaidui/Myshop/ShopProduct/ListProduct.dart';
import 'package:thaidui/NotFound/NotFound.dart';
import 'package:thaidui/Page/ForGetPassword/Input_OtpAnd_password.dart';
import 'package:thaidui/Page/home.dart';
import 'package:thaidui/Myshop/ShopProduct/Add_product.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Product/ProductDetails.dart';
import 'package:thaidui/Profiles/Profiles.dart';
import 'package:thaidui/Recharge/%20recharge_account.dart';
import 'package:thaidui/Video/Add_Video.dart';
import 'package:thaidui/Video/Edit_image.dart';
import 'package:thaidui/Video/Get_All_Video.dart';

void main() async {
  runApp(const MyApp());
  // final storage = FlutterSecureStorage();
  // storage.delete(key: 'access_token');

  // final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  // print('Listening on port ${server.port}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: homepage());
  }
}
