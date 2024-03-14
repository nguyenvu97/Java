import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:thaidui/Cart/cart.dart';
import 'package:thaidui/Footer/BootomNav.dart';
import 'package:thaidui/History_Order_and_More/History_Order.dart';
import 'package:thaidui/History_Order_and_More/NotPayMent_orderFail.dart';
import 'package:thaidui/Myshop/update_Shop.dart';
import 'package:thaidui/Page/home.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Recharge/%20recharge_account.dart';
import 'package:thaidui/Service/HomeService/HomeService.dart';
import 'package:thaidui/Service/HomeService/MemberData.dart';
import 'package:thaidui/Service/UserService/User.dart';
import 'package:thaidui/Service/UserService/UserService.dart';
import 'package:thaidui/Text_Icons/CreateIconButton.dart' as IconsBanner;
import 'package:thaidui/Myshop/MyShop.dart';
import 'package:thaidui/Myshop/SeeShop.dart';
import 'package:thaidui/Text_Icons/TextButton.dart';
import 'package:thaidui/Video/Add_Video.dart';

class Profiles extends StatefulWidget {
  const Profiles({super.key});

  @override
  State<Profiles> createState() => _ProfilesState();
}

UserService userService = UserService();

class _ProfilesState extends State<Profiles> {
  HomeService homeService = HomeService();
  MemberData? user;
  Future<void> checkToken() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => loginpage()));
      return null;
    }
    try {
      MemberData? user1 = await homeService.DecodeToken();
      if (user1 != null) {
        setState(() {
          user = user1;
        });
        return;
      }
      print("loi he thong ");
    } catch (e) {
      print("loi he thong $e");
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 180,
              color: Colors.orange,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5, top: 50),
                        height: 30,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            color: Colors.white),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SeeShop()));
                          },
                          child: Center(child: Text("My Shop ")),
                        ),
                      ),
                      SizedBox(
                        width: 240,
                      ),
                      Container(
                        height: 30,
                        margin: EdgeInsets.only(bottom: 5, top: 50),
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: EdgeInsets.only(bottom: 5, left: 10, top: 50),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => homepage()));
                          },
                          child: Icon(
                            Icons.shopping_basket_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: EdgeInsets.only(bottom: 5, left: 10, top: 50),
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.messenger,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 430,
                    height: 95,
                    child: Row(children: [
                      Container(
                        width: 90,
                        margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.black26,
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://toppng.com/uploads/preview/circled-user-icon-user-pro-icon-11553397069rpnu1bqqup.png'),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15, bottom: 5, left: 10),
                        child: Column(
                          children: [
                            Container(
                              height: 35,
                              child: Text(user?.sub ?? "name"),
                            ),
                            Container(
                              height: 35,
                              child: Text(user?.phone ?? "phone"),
                            ),
                          ],
                        ),
                      )
                    ]),
                  )
                ],
              ),
            ),
            Container(
              height: 5,
              color: Color.fromARGB(255, 225, 212, 212),
            ),
            Column(
              children: [
                Container(
                  height: 50,
                  child: GestureDetector(
                    onTap: () {
                      print("abc");
                    },
                    child: Row(
                      children: [
                        Icon(Icons.mobile_friendly),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "don nap the vs dich vu ",
                        ),
                        SizedBox(
                          width: 210,
                        ),
                        Icon(Icons.more_horiz)
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 0.5,
                  color: Color.fromARGB(255, 225, 212, 212),
                ),
                Container(
                  height: 50,
                  child: GestureDetector(
                    onTap: () {
                      print("abc");
                    },
                    child: Row(
                      children: [
                        Container(height: 120, child: Icon(Icons.history)),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Don mua  ",
                        ),
                        SizedBox(
                          width: 284,
                        ),
                        Icon(Icons.more_horiz)
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 0.5,
                  color: Color.fromARGB(255, 225, 212, 212),
                ),
                IConsButton(),
                Container(
                  height: 1,
                  color: Color.fromARGB(255, 225, 212, 212),
                ),
                Column1(),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
      ),
    );
  }

  Container Column1() {
    return Container(
      // color: Colors.white,
      child: Column(children: [
        Column(children: [
          Text_Buton(
              label: "Money",
              icon: Icons.wallet,
              Notifaition: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Recharge_account()));
              }),
          Text_Buton(
            label: "cho xac nhan",
            icon: Icons.book_outlined,
            Notifaition: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotPayOrder()),
              );
            },
          ),
          Text_Buton(
              icon: Icons.wallet,
              label: 'abc',
              Notifaition: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryOrder()));
              }),
          Text_Buton(
              icon: Icons.local_shipping_outlined,
              label: 'Add Video',
              Notifaition: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddVideoUser()));
              }),
          Text_Buton(
              icon: Icons.star_outlined,
              label: 'danh gia',
              Notifaition: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => homepage()));
              }),
          Text_Buton(
              icon: Icons.book_outlined,
              label: 'cho xac nhan',
              Notifaition: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => homepage()));
              }),
        ]),
        Container(height: 5, color: Color.fromARGB(255, 225, 212, 212)),
        Column(
          children: [
            Text_Buton(
                icon: Icons.settings,
                label: 'Cai dat',
                Notifaition: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => homepage()));
                }),
            Text_Buton(
                icon: Icons.support_agent,
                label: 'Ho tro',
                Notifaition: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => homepage()));
                }),
            Text_Buton(
                icon: Icons.group,
                label: 'noi chuyen vs shop',
                Notifaition: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => homepage()));
                }),
          ],
        ),
        Container(height: 5, color: Color.fromARGB(255, 225, 212, 212)),
        Padding(
          padding: EdgeInsets.only(left: 50, right: 50, top: 10),
          child: GestureDetector(
            onTap: () {
              userService.logOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => homepage()));
            },
            child: Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 239, 59, 46)),
              child: Center(
                child: Text(
                  "LogOut",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }

  Container IConsButton() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  child: IconsBanner.CreateIconButton(
                      icon: AntDesign.wallet_fill,
                      label: "Money",
                      ontap: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              Expanded(
                child: Container(
                  child: IconsBanner.CreateIconButton(
                      icon: AntDesign.wallet_fill,
                      label: "Wallet",
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Recharge_account()));
                      }),
                ),
              ),
              Expanded(
                child: Container(
                  child: IconsBanner.CreateIconButton(
                      icon: Icons.ac_unit_outlined,
                      label: "shop",
                      ontap: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              Expanded(
                child: Container(
                  child: IconsBanner.CreateIconButton(
                      icon: Icons.ac_unit_outlined,
                      label: "shop",
                      ontap: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
