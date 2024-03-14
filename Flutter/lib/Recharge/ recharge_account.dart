import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thaidui/Myshop/SeeShop.dart';
import 'package:thaidui/Page/home.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Profiles/Profiles.dart';
import 'package:thaidui/Service/Recharge/RechargeDto.dart';
import 'package:thaidui/Service/Recharge/RechargeService.dart';
import 'package:thaidui/Text_Icons/TextButton.dart';
import 'package:url_launcher/url_launcher.dart';

class Recharge_account extends StatefulWidget {
  const Recharge_account({super.key});

  @override
  State<Recharge_account> createState() => _Recharge_accountState();
}

class _Recharge_accountState extends State<Recharge_account> {
  List<int> valueList = [100000, 200000, 300000, 400000, 500000, 600000];
  int selectedIndex = -1;
  int? valueMoney;
  TextEditingController controller = TextEditingController();
  bool isTextFieldEnabled = true;

  final RechargeServcie rechargeServcie = RechargeServcie();
  // void checkToken() async {
  //   final storage = FlutterSecureStorage();
  //   String? token = await storage.read(key: 'access_token');
  //   if (token == null && token!.isEmpty) {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => loginpage()));
  //   }
  // }

  RechargeDto? recharDto;
  Future<RechargeDto?> rechargeUser(int moneyUser) async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');
    if (token == null && token!.isEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => loginpage()));
      return null;
    }
    try {
      RechargeDto? money = await rechargeServcie.rechargeUser(moneyUser);
      if (money != null) {
        setState(() {
          recharDto = money;
        });
      } else {
        print("sai j do o day ");
      }
    } catch (e) {
      print("sai j do o day $e ");
    }
  }

  Future<void> _launchUrl(String url) async {
    Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Recharge_account()));
      throw Exception('Could not launch $_url');
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Profiles()));
    // handlePaymentSuccess();
  }

// Sử dụng hàm này để chuyển hướng

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Container(
          height: 30,
          width: 30,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        title: Text("Nap tien"),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 0.5),
                    ),
                  ),
                  child: Text("Số tiền muốn nạp"),
                ),
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          for (int i = 0; i < 3; i++)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = i;
                                    controller.text =
                                        valueList[selectedIndex].toString();
                                    isTextFieldEnabled = true;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 243, 222, 222),
                                    border: Border.all(
                                      color: selectedIndex == i
                                          ? Colors.red
                                          : Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(valueList[i].toString()),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          for (int i = 3; i < 6; i++)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = i;
                                    controller.text =
                                        valueList[selectedIndex].toString();
                                    isTextFieldEnabled = true;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 243, 222, 222),
                                    border: Border.all(
                                      color: selectedIndex == i
                                          ? Colors.red
                                          : Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(valueList[i].toString()),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Container(
          //   color: Colors.amber,
          //   margin: EdgeInsets.only(top: 20),
          //   child: Text(
          //     selectedIndex != -1
          //         ? "Giá trị đã chọn: ${valueList[selectedIndex]}"
          //         : '',
          //     style: TextStyle(fontSize: 18),
          //   ),
          // ),
          Container(
            height: 50,
            width: 400,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: TextField(
              controller: controller,
              enabled: isTextFieldEnabled,
              onChanged: (value) {
                setState(() {
                  valueMoney = int.tryParse(value) ?? 0;
                  selectedIndex = -1;
                  isTextFieldEnabled = true;
                });
              },
              decoration: InputDecoration(
                hintText: isTextFieldEnabled
                    ? "Người dùng nhập tiền vào đây"
                    : "Số tiền đã chọn: ${valueList[selectedIndex]}",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () async {
            if (selectedIndex != -1) {
              await rechargeUser(valueList[selectedIndex]);
              _launchUrl(recharDto?.url ?? "");
            } else if (valueMoney != null) {
              await rechargeUser(valueMoney!);

              _launchUrl(recharDto?.url ?? "");
            }
          },
          child: Container(
            color: Colors.red,
            child: Center(child: Text("PayMent")),
          ),
        ),
      ),
    );
  }
}
