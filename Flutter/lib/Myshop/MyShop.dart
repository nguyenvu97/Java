import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thaidui/Page/home.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Product/Product.dart';
import 'package:file_picker/file_picker.dart';
import 'package:thaidui/Product/ProductDetails.dart';
import 'package:thaidui/Service/ProductService/ProductEntity.dart';
import 'package:thaidui/Service/ShopService/ShopService.dart';

class MyShop extends StatefulWidget {
  final int id;
  MyShop({super.key, required this.id});

  @override
  State<MyShop> createState() => _MyShopState();
}

class _MyShopState extends State<MyShop> {
  int _currentIndex = 0;
  void checkToken() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');
    if (token == null && token!.isEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => loginpage()));
    }
  }

  final ShopService shopService = ShopService();
  List<ProductEntity>? top3Product;
  Future<void> topNewProduct() async {
    try {
      List<ProductEntity>? products = await shopService.top3NewProductInStore();
      print(products);
      if (products != null) {
        setState(() {
          top3Product = products;
        });
        return;
      }
      print("loi he thong");
    } catch (e) {
      print("loi he thong top3");
    }
  }

  List<ProductEntity> countProduct = [];
  Future<void> countCategoryInProduct(String category) async {
    print(category);
    try {
      List<ProductEntity>? products = await shopService.countCategory(category);

      if (products != null) {
        print(products);
        setState(() {
          countProduct = products;
        });
        return;
      }
      print("loi countCategoryInProduct");
    } catch (e) {
      print("loi he thong countCategoryInProduct $e");
    }
  }

  final List<String> items = [
    "day",
    "clothing",
    "food",
    "medicine",
    "phone",
    "watch",
    "cosmetics",
    "health",
  ];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    ListProductShop();
    topNewProduct();
  }

  List<ProductEntity>? product = [];

  Future<void> ListProductShop() async {
    checkToken();
    try {
      List<ProductEntity>? product1 = await shopService.getAllProductForStore();
      if (product1 != null) {
        setState(() {
          product = product1;
        });
        print(product1);
        return;
      } else {
        product == null;
        print("ko goi len dc listProductSHop");
      }
    } catch (e) {
      print("loi he thong $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(60.0), // Đặt chiều cao mong muốn cho AppBar
        child: AppBar(
          actions: [
            searchProduct(),
          ],
          leading: Container(
            height: 30,
            width: 30,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            infomationShop(),
            Container(
              height: 0.5,
              color: Color.fromARGB(255, 225, 212, 212),
            ),
            Container(
              height: 50,
              width: 430,
              child: Row(
                children: [
                  Expanded(
                    child: buildTab('Shop', 0),
                  ),
                  Expanded(
                    child: buildTab('Product', 1),
                  ),
                  Expanded(
                    child: buildTab('Category', 2),
                  ),
                ],
              ),
            ),
            Container(
              height: 0.5,
              color: Color.fromARGB(255, 225, 212, 212),
            ),
            getContentWidget(),
          ],
        ),
      ),
    );
  }

  GestureDetector buildTab(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Color.fromARGB(255, 225, 212, 212),
              width: 0.5,
              style: BorderStyle.solid,
            ),
          ),
          color: _currentIndex == index ? Colors.blue : Colors.white,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: _currentIndex == index ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget Shop() {
    if (top3Product == null) {
      return Container(
        child: Text('Không có sản phẩm'),
      );
    }
    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: top3Product!.map((productEntity) {
          return buildProductTop3(productEntity);
        }).toList(),
      ),
    );
  }

  Widget buildProductTop3(ProductEntity productEntity) {
    return Container(
      height: 200,
      width: 200,
      margin: EdgeInsets.only(left: 10, top: 10),
      decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromARGB(255, 225, 212, 212), width: 0.5),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(
            height: 140,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'http://localhost:9091/api/v1/product/fileSystem/${productEntity.img}'),
                  fit: BoxFit.cover),
              border: Border(
                  bottom: BorderSide(
                      color: Color.fromARGB(255, 225, 212, 212), width: 0.5)),
            ),
          ),
          Container(
            child: Column(children: [
              Text(productEntity.productName),
              Text(productEntity.price.toString())
            ]),
          )
        ],
      ),
    );
  }

  Container infomationShop() {
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
            ),
            child: Center(child: Text("Icon")),
          ),
          Container(
            width: 200,
            margin: EdgeInsets.only(top: 15, bottom: 5, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 35,
                  child: Text("Name"),
                ),
                Container(
                  height: 35,
                  child: Text("Phone"),
                ),
              ],
            ),
          ),
          // Container(
          //   width: 90,
          //   height: 40,
          //   margin: EdgeInsets.only(left: 10, top: 5, bottom: 5),
          //   decoration: BoxDecoration(
          //     border: Border.all(width: 1, color: Colors.black),
          //     color: Colors.white,
          //   ),
          //   child: GestureDetector(
          //     onTap: () {},
          //     child: Center(
          //         child: Text(
          //       "Shop view",
          //       style: TextStyle(color: Colors.black),
          //     )),
          //   ),
          // ),
        ],
      ),
    );
  }

  Container searchProduct() {
    return Container(
      child: Column(
        children: [
          Container(
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
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search Product',
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(Icons.search),
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
                      onPressed: () {}, icon: Icon(Icons.more_horiz)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container ListCategory() {
    if (countProduct == null) {
      return Container(
        child: Center(child: Text('not found product')),
      );
    }
    return Container(
      height: 70,
      width: 430,
      child: GestureDetector(
        onTap: () {},
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.only(left: 10, top: 10),
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(30),
            //     border: Border.all(color: Colors.black, width: 0.5),
            //     image: DecorationImage(image: AssetImage(""))),
          ),
          Container(
            height: 50,
            width: 200,
            margin: EdgeInsets.only(left: 10, top: 20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(countProduct!.length.toString()),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 8),
            child: Container(
              height: 50,
              width: 140,
              child: Icon(Icons.more_horiz),
            ),
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
                  child: Text("cho lay hang "),
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
                  child: Center(child: Text(product.toString())),
                ),
                Container(
                  height: 35,
                  child: Text("cho lay hang "),
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
                  child: Center(child: Text(product.toString())),
                ),
                Container(
                  height: 35,
                  child: Text("cho lay hang "),
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
                  child: Center(child: Text(product.toString())),
                ),
                Container(
                  height: 35,
                  child: Text("cho lay hang "),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget getContentWidget() {
    print("_currentIndex in getContentWidget: $_currentIndex");
    if (_currentIndex == 0) {
      if (product!.isEmpty) {
        print(product);
        return Center(
          child: Text('Product is null'),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Đảm bảo rằng children của Column sẽ căn chỉnh theo chiều ngang
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 20,
            ),
            child: TextButton(
              onPressed: () {},
              child: Text(
                "New Product",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Shop(),
          ProductPage(
            productList: product!,
            name: "All Product",
          ),
        ],
      );
    }
    if (_currentIndex == 1) {
      if (product!.isEmpty) {
        return Center(
          child: Text('Product is null'),
        );
      }
      return ProductPage(
        productList: product!,
        name: "List Product",
      );
    }
    if (_currentIndex == 2) {
      // if (countProduct!.isEmpty) {
      //   return Center(
      //     child: Text('Product is null'),
      //   );
      // }
      return Column(
        children: [
          buildCategory(),
          Container(
            height: 50,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0.5, color: Colors.black)),
            child: GestureDetector(
              onTap: () {
                countCategoryInProduct(selectedValue!);
              },
              child: Center(
                child: Text(
                  'Ok',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          ProductPage(
              productList: countProduct,
              name: "Search Product: ${countProduct.length.toString()}"),
        ],
      );
    }
    return Shop();
  }

  Widget buildCategory() {
    return Container(
      margin: EdgeInsets.all(10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.list,
                size: 16,
                color: Colors.black,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  'Chon ngang hang ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: items
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: 400,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.black12, width: 2)),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            iconSize: 14,
            iconEnabledColor: Colors.black12,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }
}
