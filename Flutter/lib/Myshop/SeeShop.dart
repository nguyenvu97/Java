import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:thaidui/Myshop/MyShop.dart';
import 'package:thaidui/Myshop/ShopProduct/Finance_Shop.dart';
import 'package:thaidui/Myshop/ShopProduct/ListProduct.dart';
import 'package:thaidui/Myshop/update_Shop.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Service/Order_Details/Order_Details_Service.dart';
import 'package:thaidui/Service/ShopService/Shop.dart';
import 'package:thaidui/Service/ShopService/Shop.dart';

import 'package:thaidui/Service/ShopService/ShopService.dart';
import 'package:thaidui/Text_Icons/createIconButton.dart' as customIcons;

class SeeShop extends StatefulWidget {
  const SeeShop({super.key});

  @override
  State<SeeShop> createState() => _SeeShopState();
}

Store? shop;

class _SeeShopState extends State<SeeShop> {
  int product = 0;
  int product1 = 0;
  int product2 = 0;
  int product3 = 0;

  final ShopService shopService = ShopService();
  final orderDetails = OrderDetailsService();
  @override
  void initState() {
    super.initState();
    OpenShop();
    countOrderSUCCESS();
    countOrderREFUND();
    countOrderFAIL();
    countOrderUNPAID();
  }

  final storage = FlutterSecureStorage();

  Future<void> OpenShop() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null || token.isEmpty) {
      return;
    }
    try {
      Store? openedShop = await shopService.OpenShop();
      if (openedShop != null) {
        print(openedShop);
        setState(() {
          shop = openedShop;
        });
        print('Shop opened successfully: ');
      } else {
        print("shop not ok");
      }
    } catch (e) {
      print('Error while opening shop: $e');
    }
  }

/**
 * countOrderDetailsShop
 * 
 */
  Future<void> countOrderSUCCESS() async {
    try {
      int? abc = await orderDetails.countOrderSUCCESS();
      if (abc! > 0) {
        setState(() {
          product = abc;
        });
        return;
      }
      print("loi he thong");
    } catch (e) {
      print("loi he thong $e");
    }
  }

  Future<void> countOrderREFUND() async {
    try {
      int? abc = await orderDetails.countOrderREFUND();
      if (abc! > 0) {
        setState(() {
          product1 = abc;
        });
        return;
      }
      print("loi he thong");
    } catch (e) {
      print("loi he thong $e");
    }
  }

  Future<void> countOrderFAIL() async {
    try {
      int? abc = await orderDetails.countOrderFAIL();
      if (abc! > 0) {
        setState(() {
          product2 = abc;
        });
        return;
      }
      print("loi he thong");
    } catch (e) {
      print("loi he thong $e");
    }
  }

  Future<void> countOrderUNPAID() async {
    try {
      int? abc = await orderDetails.countOrderUNPAID();
      if (abc! > 0) {
        setState(() {
          product3 = abc;
        });
        return;
      }
      print("loi he thong");
    } catch (e) {
      print("loi he thong $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(70.0), // Đặt chiều cao mong muốn cho AppBar
        child: AppBar(
          leading: Container(
            height: 30,
            width: 30,
            margin: EdgeInsets.only(left: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
          ),
          elevation: 2,
          actions: [heard()],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UpdateShop()));
            },
            child: Shop(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyShop(
                            id: shop!.id,
                          )));
            }),
          ),
          Container(
            height: 5,
            color: Color.fromARGB(255, 225, 212, 212),
          ),
          Container(
            height: 145,
            child: Column(children: [
              Container(
                height: 35,
                width: 430,
                child: Row(children: [
                  Center(
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.all(8),
                      child: Text("don hang "),
                    ),
                  ),
                  Container(
                    width: 200,
                    margin: EdgeInsets.only(left: 130),
                    child: Center(
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Xem lich su giao dich >",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                    ),
                  )
                ]),
              ),
              HistoryOrderShop(),
              Container(
                height: 5,
                color: Color.fromARGB(255, 225, 212, 212),
              ),
            ]),
          ),
          Container(
            height: screenSize.height * 0.1,
            child: IConsButton(context),
          )
        ]),
      ),
    );
  }

  Container HistoryOrderShop() {
    return Container(
      height: 100,
      width: 430,
      margin: EdgeInsets.only(right: 10, bottom: 5),
      child: Row(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: const Color.fromARGB(255, 239, 182, 182), width: 1)),
            margin: EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 50,
                  child: Center(child: Text(product.toString())),
                ),
                Container(
                  height: 35,
                  child: Text("Order SUCCESS"),
                )
              ],
            ),
          )),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: const Color.fromARGB(255, 239, 182, 182), width: 1)),
            margin: EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 50,
                  child: Center(child: Text(product1.toString())),
                ),
                Container(
                  height: 35,
                  child: Text("Order REFUND"),
                )
              ],
            ),
          )),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: const Color.fromARGB(255, 239, 182, 182), width: 1)),
            margin: EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 50,
                  child: Center(child: Text(product2.toString())),
                ),
                Container(
                  height: 35,
                  child: Text("Order FAIL"),
                )
              ],
            ),
          )),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: const Color.fromARGB(255, 239, 182, 182), width: 1)),
            margin: EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 50,
                  child: Center(child: Text(product3.toString())),
                ),
                Container(
                  height: 35,
                  child: Text("Order UNPAID"),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}

@override
Widget heard() {
  return Container(
    height: 50,
    width: 430,
    child: Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 50),
          child: Text(
            "Shop cua toi ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(left: 170),
          child: GestureDetector(
            onTap: () {},
            child: Icon(Icons.settings),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(left: 5),
          child: GestureDetector(
            onTap: () {},
            child: Icon(Icons.notifications),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(left: 5),
          child: GestureDetector(
            onTap: () {},
            child: Icon(Icons.message),
          ),
        )
      ],
    ),
  );
}

Widget IConsButton(BuildContext context) {
  return Container(
    child: Column(
      children: [
        Row(
          children: [
            customIcons.CreateIconButton(
                icon: Icons.add_home,
                label: "Product",
                ontap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListProdcut()));
                }),
            customIcons.CreateIconButton(
                icon: Icons.attach_money,
                label: "finance",
                ontap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Finance_shop()));
                }),
            customIcons.CreateIconButton(
                icon: Icons.shop, label: "Marketing", ontap: () {}),
            customIcons.CreateIconButton(
                icon: Icons.support_agent, label: "support", ontap: () {})
          ],
        ),
      ],
    ),
  );
}

Container Shop(VoidCallback onTap) {
  if (shop?.image != null) {
    return Container(
      height: 100,
      child: Row(
        children: [
          Container(
            width: 90,
            margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.black26,
                image: DecorationImage(
                    image: NetworkImage(
                        'http://localhost:9091/api/v1/store/fileSystem/${shop?.image ?? ''}'),
                    fit: BoxFit.cover)),
          ),
          Container(
            width: 200,
            margin: EdgeInsets.only(top: 15, bottom: 5, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 35,
                  child: Text(shop?.shopName ?? "shopname"),
                ),
                Container(
                  height: 35,
                  child: Text(shop?.shopPhone ?? "shopPhone"),
                ),
              ],
            ),
          ),
          Container(
            width: 90,
            height: 40,
            margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              color: Colors.white,
            ),
            child: GestureDetector(
              onTap: onTap,
              child: Center(
                  child: Text(
                "MyShop",
                style: TextStyle(color: Colors.black),
              )),
            ),
          ),
        ],
      ),
    );
  }
  return Container(
    height: 100,
    child: Row(
      children: [
        Container(
          width: 90,
          margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.black26,
              image: DecorationImage(
                  image: NetworkImage(
                      'https://e7.pngegg.com/pngimages/705/224/png-clipart-user-computer-icons-avatar-miscellaneous-heroes.png'),
                  fit: BoxFit.cover)),
        ),
        Container(
          width: 200,
          margin: EdgeInsets.only(top: 15, bottom: 5, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 35,
                child: Text(shop?.shopName ?? "shopname"),
              ),
              Container(
                height: 35,
                child: Text(shop?.shopPhone ?? "shopPhone"),
              ),
            ],
          ),
        ),
        Container(
          width: 90,
          height: 40,
          margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            color: Colors.white,
          ),
          child: GestureDetector(
            onTap: onTap,
            child: Center(
                child: Text(
              "MyShop",
              style: TextStyle(color: Colors.black),
            )),
          ),
        ),
      ],
    ),
  );
}
