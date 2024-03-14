import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thaidui/Myshop/ShopProduct/Add_product.dart';
import 'package:thaidui/Myshop/ShopProduct/Update_Product_Shop.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Service/ProductService/ProductEntity.dart';
import 'package:thaidui/Service/ShopService/ProductAdd.dart';
import 'package:thaidui/Service/ShopService/ShopService.dart';

class ListProdcut extends StatefulWidget {
  const ListProdcut({super.key});

  @override
  State<ListProdcut> createState() => _ListProdcutState();
}

class _ListProdcutState extends State<ListProdcut> {
  void checkToken() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => loginpage()));
    }
  }

  List<ProductEntity>? product;
  final ShopService shopService = ShopService();
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
        print("ko goi len dc listProductSHop");
      }
    } catch (e) {
      print("loi he thong $e");
    }
  }

  @override
  void initState() {
    ListProductShop();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
              backgroundColor: Colors.white,
              title: Text("List Product"),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new))),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [buildCartList()]),
        ),
        bottomNavigationBar: BottomAppBar(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddProduct()));
            },
            child: Container(
              height: screenSize.height * 0.07,
              color: Colors.red,
              child: Center(child: Text("AddProduct")),
            ),
          ),
        ));
  }

  Widget buildCartList() {
    if (product == null || product!.isEmpty) {
      // Hiển thị thông báo khi danh sách rỗng
      return Center(
        child: Text("No products available"),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: product!.length,
      itemBuilder: (context, index) {
        // Hiển thị thông tin sản phẩm tại vị trí index
        return Column(
          children: [
            Divider(thickness: 1, color: Colors.grey),
            Row(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "http://localhost:9091/api/v1/product/fileSystem/${product![index].img}")),
                      borderRadius: BorderRadius.circular(20)),
                ),
                Column(
                  children: [
                    Container(
                        height: 50,
                        width: 140,
                        margin: EdgeInsets.only(left: 10, top: 10),
                        child: Text(
                            "productName : ${product![index].productName}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))),
                    Container(
                      height: 50,
                      width: 140,
                      margin: EdgeInsets.only(left: 10, bottom: 20),
                      child: Text(
                        "productName : ${product![index].price}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 70,
                  width: 50,
                  margin: EdgeInsets.only(left: 10),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateProductStore(
                                    productID: product![index].id)));
                      },
                      icon: Icon(
                        Icons.system_update_alt,
                        color: Colors.green,
                      )),
                ),
                Container(
                  height: 70,
                  width: 50,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                )
              ],
            ),
            Container(
              height: 70,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 0.5,
                      color: const Color.fromARGB(255, 225, 153, 153))),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 70,
                      child: Center(
                          child:
                              Text("Quantity : ${product![index].quantity}")),
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color:
                                      const Color.fromARGB(255, 240, 151, 151),
                                  width: 0.5))),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 70,
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color:
                                      const Color.fromARGB(255, 240, 151, 151),
                                  width: 0.5))),
                      child: Center(
                          child: Text(
                              "Create Product : ${product![index].createAt}")),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 70,
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color:
                                      const Color.fromARGB(255, 240, 151, 151),
                                  width: 0.5))),
                      child: product![index].status == 'IN'
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : Icon(Icons.check_circle_outline, color: Colors.red),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
