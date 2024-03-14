import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thaidui/Myshop/SeeShop.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Profiles/Profiles.dart';
import 'package:thaidui/Service/HomeService/HomeService.dart';
import 'package:thaidui/Service/HomeService/MemberData.dart';
import 'package:thaidui/Service/ShopService/ShopService.dart';

class UpdateShop extends StatefulWidget {
  const UpdateShop({super.key});

  @override
  State<UpdateShop> createState() => _UpdateShopState();
}

MemberData? memberData;
HomeService homeService = HomeService();

final storage = FlutterSecureStorage();

class _UpdateShopState extends State<UpdateShop> {
  ShopService shopService = ShopService();
  String _filePath = "";
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _filePath = pickedImage.path;
      });
      File image = File(_filePath);
      await shopService.updateImage(image);
    }
  }

  Future<void> updateShop() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null || token.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => loginpage()),
      );
      return;
    }
    try {
      MemberData? memberData1 = await homeService.DecodeToken();
      if (memberData1 != null) {
        setState(() {
          memberData = memberData1;
        });
      }
    } catch (e) {
      print('Error while opening shop: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    updateShop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          height: 50,
          width: 50,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profiles()),
              );
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: Container(),
    );
  }
}
