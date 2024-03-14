import 'package:flutter/material.dart';
import 'package:thaidui/Cart/cart.dart';
import 'package:thaidui/Myshop/MyShop.dart';
import 'package:thaidui/Myshop/SeeShop.dart';
import 'package:thaidui/Product/Product.dart';
import 'package:thaidui/Service/CartRedisService/Cart.dart';
import 'package:thaidui/Service/CartRedisService/Cart_Redis_Service.dart';
import 'package:thaidui/Service/ProductService/ProductEntity.dart';
import 'package:thaidui/Service/ProductService/ProductService.dart';

class ProductDetails extends StatefulWidget {
  final int productID;

  // Constructor
  const ProductDetails({Key? key, required this.productID}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

/*
productInfo
addCartRedis
 */

class _ProductDetailsState extends State<ProductDetails> {
  TextEditingController _quantityController = TextEditingController();
  ProductEntity? product; // Thêm "?" để cho phép giá trị là null
  final ProductService productService = ProductService();
  Cart? cartitem;
  final CartRedisService cartRedisService = CartRedisService();

  Future<void> productInfo() async {
    if (widget.productID == null) {
      print("abc");
    }
    try {
      ProductEntity? fetchedProduct =
          await productService.getByProductId(widget.productID);
      print(widget.productID);
      // print("thaidui + ${fetchedProduct!.id}");
      if (fetchedProduct != null) {
        print(widget.productID);

        setState(() {
          product = fetchedProduct;
        });
        print("thaidui + ${product!.id}");
      } else {
        print('Product not found');
      }
    } catch (error) {
      print('Error loading product: ');
    }
  }

  Future<void> addCartRedis(int quantity) async {
    try {
      Cart? addCart =
          await cartRedisService.addCartRedis(widget.productID, quantity);
      print(widget.productID.runtimeType);
      print(addCart.runtimeType);
      if (addCart != null) {
        setState(() {
          cartitem = addCart;
        });
        print('Product added to cart successfully.');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => cart()));
      } else {
        print('Failed to add product to cart.');
      }
    } catch (e) {
      print("loi he thong + $e");
    }
  }

  @override
  void initState() {
    super.initState();
    productInfo();
  }

  int money = 15000;

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    DateTime now = DateTime.now();
    DateTime add3day = now.add(Duration(days: 3));
    DateTime onlyDate = DateTime(add3day.year, add3day.month, add3day.day);

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 400,
              width: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: NetworkImage(
                      'http://localhost:9091/api/v1/product/fileSystem/${product?.img ?? ''}'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 250, right: 350),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  height: 50,
                  width: 500,
                  margin: EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    product?.productName ?? '', // Sử dụng dữ liệu từ product
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 30,
                  width: 500,
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "⭐️⭐️⭐️⭐️⭐️5 | Price  : ${product?.price ?? ''}", // Sử dụng dữ liệu từ product
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Container(
              height: 10,
              color: Color.fromARGB(255, 225, 212, 212),
            ),
            Column(
              children: [
                Container(
                  height: 20,
                  width: 500,
                  margin: EdgeInsets.only(left: 10, top: 10),
                  child: Text("SHIP MONEY :" + money.toString()),
                ),
                Container(
                  height: 20,
                  width: 500,
                  margin: EdgeInsets.only(left: 10),
                  child: Text("ngay nhan san pham neu bay gio dat hang " +
                          "{${onlyDate.day}/${onlyDate.month}/${onlyDate.year}}"
                              .toString()
                      // startDate.toString()
                      ),
                )
              ],
            ),
            Container(
              height: 10,
              color: Color.fromARGB(255, 225, 212, 212),
            ),
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                          image: AssetImage("asset/login.png"))),
                ),
                Container(
                  height: 100,
                  width: 200,
                  margin: EdgeInsets.only(bottom: 10, top: 10, left: 10),
                  child: Column(children: [
                    Container(
                      height: 30,
                      width: 200,
                      child: Text("shopname"),
                    ),
                    Container(
                      height: 30,
                      width: 200,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Icon(Icons.online_prediction_sharp,
                              color: Colors.black),
                          SizedBox(width: 5),
                          Text("8h truoc"),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 200,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Icon(Icons.add_reaction, color: Colors.black),
                          SizedBox(width: 5),
                          Text("dia chi shop"),
                        ],
                      ),
                    ),
                  ]),
                ),
                Container(
                  height: 30,
                  width: 80,
                  margin: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 1)),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyShop(
                                      id: product!.storeId,
                                    )));
                      },
                      child: Text("See Shop"),
                    ),
                  ),
                ),
                Container()
              ],
            ),
            Container(
              height: 10,
              color: Color.fromARGB(255, 225, 212, 212),
            ),
            // Productpage()
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      width: 100,
                      color: const Color.fromARGB(255, 73, 168, 245),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.message),
                          Text("Chat Now"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showQuantityDialog();
                    },
                    child: Container(
                      height: 50,
                      width: 100,
                      color: Color.fromARGB(255, 119, 185, 239),
                      child: Column(
                        children: [
                          Container(
                            height: 38,
                            child:
                                Icon(Icons.shopping_cart, color: Colors.black),
                          ),
                          Container(
                            child: Text(
                              "Add Cart",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     _showQuantityDialog();
                //   },
                //   child: Container(
                //     height: 60,
                //     width: 230,
                //     color: Color.fromARGB(255, 245, 73, 79),
                //     child: Center(child: Text("BUY NOW")),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showQuantityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Quantity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                int quantity = int.tryParse(_quantityController.text) ?? 1;
                addCartRedis(quantity);
                Navigator.of(context).pop();
              },
              child: Text('Add to Cart'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
