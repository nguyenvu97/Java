import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:thaidui/Cart/cart.dart';
import 'package:thaidui/Footer/BootomNav.dart';
import 'package:thaidui/Banner/banner_model.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Product/Product.dart';
import 'package:thaidui/Profiles/Profiles.dart';
import 'package:thaidui/Recharge/%20recharge_account.dart';
import 'package:thaidui/Service/HomeService/HomeService.dart';
import 'package:thaidui/Service/HomeService/MemberData.dart';
import 'package:thaidui/Service/ProductService/ProductEntity.dart';
import 'package:thaidui/Service/ProductService/ProductService.dart';
import 'package:thaidui/Sreach_ListProduct/Sreach_Prodcut.dart';

import 'package:thaidui/Text_Icons/createIconButton.dart' as customIcons;
import 'package:thaidui/Video/Get_All_Video.dart';

class homepage extends StatefulWidget {
  homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Banner_Model> banner_model = [];
  final HomeService homeService = HomeService();

  void _getcategory() {
    banner_model = Banner_Model.getBanner();
  }

  @override
  void initState() {
    _getcategory();
    // decodeToken();
    fetchProducts();
    fetchAndUploadImages();
    // checkLogin();
  }

  Future<void> fetchAndUploadImages() async {
    try {
      for (ProductEntity product in productList) {
        String imageUrl = await productService.uploadImage(product.img);

        // Cập nhật product.img thành đường dẫn đầy đủ
        product.img =
            'http://localhost:9091/api/v1/product/fileSystem/$imageUrl';
      }
      // Bắt buộc Flutter vẽ lại widget sau khi đã tải xong ảnh
      setState(() {});
    } catch (error) {
      print('Error loading images: $error');
    }
  }

  final ProductService productService = ProductService();
  List<ProductEntity> productList = [];

  Future<void> fetchProducts() async {
    try {
      List<ProductEntity> products = await productService.getAllProduct();

      setState(() {
        productList = products;
      });
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  int _currentIndex = 0;

/**
 * Open login and off Login
 */
  // final storage = FlutterSecureStorage();
  // Future<bool> checkLogin() async {
  //   String? test = await storage.read(key: 'access_token');
  //   if (test == null) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    _getcategory();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(80.0), // Đặt chiều cao mong muốn cho AppBar
        child: AppBar(
            actions: [searchProduct()],
            leading: Container(
              height: 50,
              width: 50,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profiles()));
                  },
                  icon: Icon(Icons.person_4)),
            )),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // bannner
            Banner(),
            //  Category
            Category(),
            // Container(
            //   height: 10,
            //   color: Color.fromARGB(255, 225, 212, 212),
            // ),
            ProductPage(
              productList: productList,
              name: "Product",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
      ),
    );
  }

  Container Category() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.blue.withOpacity(1),
            BlendMode.overlay,
          ),
          image: NetworkImage(
            'https://files.123freevectors.com/wp-content/original/154027-abstract-blue-and-white-background-design.jpg',
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      transform: Matrix4.rotationX(0.1),
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "Menu",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                  left: 270,
                ),
                child:
                    IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)))
          ]),
          Column(
            children: [
              IConsButton(),
            ],
          )
        ],
      ),
    );
  }

  SingleChildScrollView Banner() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: banner_model.asMap().entries.map((entry) {
          int index = entry.key;
          Banner_Model banner = entry.value;

          return Container(
            margin: EdgeInsets.all(5),
            width: 180,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(banner.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Container(
                      width: 100,
                      child: Text(
                        banner.dicconst,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.white54,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Xử lý khi nhấn vào nút "SHOP NOW"
                        },
                        child: Center(
                          child: Text(
                            "SHOP NOW",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Container searchProduct() {
    TextEditingController _searchController = TextEditingController();
    ProductService _productService = ProductService();
    List<ProductEntity> _searchResult = [];
    void _performSearch() async {
      String keyword = _searchController.text.trim();

      if (keyword.isNotEmpty) {
        List<ProductEntity> result =
            await _productService.searchProduct(keyword);
        if (result.isEmpty) {
          print(result);
          setState(() {
            _searchResult = result;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SreachListProduct(productList: _searchResult)));
          });
        }
      }
    }

    return Container(
      child: Row(
        children: [
          Container(
            width: 300,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white10.withOpacity(0.11),
                  blurRadius: 40,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search Product',
                hintStyle: const TextStyle(
                  color: Colors.black26,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(15),
                  child: IconButton(
                    onPressed: _performSearch,
                    icon: Icon(Icons.search),
                  ),
                ),
                suffixIcon: Container(
                  width: 100,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      VerticalDivider(
                        // color: Colors.black,
                        indent: 10,
                        endIndent: 10,
                        thickness: 0.1,
                      ),
                    ],
                  ),
                ),
                contentPadding: EdgeInsets.all(15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Container(
            width: 40,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(60),
            ),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => cart()));
                },
                icon: Icon(Icons.shopping_cart)),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            width: 40,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(60),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => loginpage()),
                );
              },
              icon: Icon(Icons.notifications_active),
            ),
          ),
        ],
      ),
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
                  child: customIcons.CreateIconButton(
                      icon: Icons.shopify,
                      label: "shop",
                      ontap: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              Expanded(
                child: Container(
                  child: customIcons.CreateIconButton(
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
                  child: customIcons.CreateIconButton(
                      icon: BoxIcons.bxs_cookie,
                      label: "Shop food",
                      ontap: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              Expanded(
                child: Container(
                  child: customIcons.CreateIconButton(
                      icon: Icons.phone_android,
                      label: "Phone recharge",
                      ontap: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: customIcons.CreateIconButton(
                      icon: HeroIcons.play_circle,
                      label: "Video",
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GetallVideo()));
                      }),
                ),
              ),
              Expanded(
                child: Container(
                  child: customIcons.CreateIconButton(
                      icon: Icons.ac_unit_outlined,
                      label: "shop",
                      ontap: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              Expanded(
                child: Container(
                  child: customIcons.CreateIconButton(
                      icon: Icons.ac_unit_outlined,
                      label: "shop",
                      ontap: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              Expanded(
                child: Container(
                  child: customIcons.CreateIconButton(
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
