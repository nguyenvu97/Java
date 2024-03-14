import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thaidui/CheckOut/CheckOut.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Service/CartRedisService/Cart.dart';
import 'package:thaidui/Service/CartRedisService/Cart_Redis_Service.dart';

class cart extends StatefulWidget {
  const cart({
    Key? key,
  }) : super(key: key);

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  List<Cart> cart = [];

  void checkToken() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => loginpage()));
    }
  }

  final CartRedisService cartRedisService = CartRedisService();

  Future<void> GetallCart() async {
    checkToken();
    try {
      List<Cart>? listCart = await cartRedisService.GetallCartRedis();
      print(listCart);
      if (listCart != null) {
        setState(() {
          cart = listCart;
        });
        print('Product added to cart successfully.');
      } else {
        print('Failed to add product to cart.');
      }
    } catch (e) {
      print("loi he thong + $e");
    }
  }

  Future<void> deleteCart(int productIds) async {
    try {
      String result = await cartRedisService.deleteProductCart(productIds);
      if (result == 'delete ok') {
        await GetallCart();
        print('Product deleted from cart successfully.');
      } else {
        print('Failed to delete product from cart: $result');
      }
    } catch (e) {
      print('System error: $e');
    }
  }

  Future<void> updateQuantity(int productId, int newQuantity) async {
    try {
      Cart? updateCart =
          await cartRedisService.UpdateQuantity(productId, newQuantity);
      if (updateCart != null) {
        await GetallCart();
      }
    } catch (e) {
      print("loi he thong + $e");
    }
  }

  @override
  void initState() {
    super.initState();
    GetallCart();
  }

  int quantity = 1;
  bool isChecked = false;
  int price = 10000000;
  bool checkbox = false;
  double totalMoney = 0.0;
  void updateTotalMoney() {
    for (Cart cartItem in cart) {
      if (cartItem.isSelected) {
        totalMoney += cartItem.price * cartItem.quantity;
      } else {
        totalMoney = 0.0;
      }
    }
  }

  void toggleSelection(Cart cartItem) {
    setState(() {
      cartItem.isSelected = !cartItem.isSelected;
      updateTotalMoney();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 243, 235, 235),
        title: Text(
          "C A R T",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: Container(
          height: 20,
          width: 20,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.message))],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: 450,
          child: Column(
            children: [
              buildCartList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        color: const Color.fromARGB(255, 255, 253, 253),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                color: Color.fromARGB(255, 242, 215, 132),
                child: Center(
                    child: Text(
                  "tong tien :$totalMoney",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
              ),
            ),
            Expanded(
              child: Container(
                height: 50,
                color: Colors.red,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      List<Cart> selectedProducts = cart
                          .where((cartItem) => cartItem.isSelected)
                          .toList();
                      print(selectedProducts);
                      if (selectedProducts.length > 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Checkout(cart1: selectedProducts),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text("BUY NOW",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container ShipMoney() {
    return Container(
      height: 50,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20),
            height: 50,
            width: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: IconButton(
                onPressed: () {}, icon: Icon(Icons.local_shipping_sharp)),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text("Giam gia don toi thieu tren 200k la 15 k tien ship"),
          ),
        ],
      ),
    );
  }

  Widget buildCartList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: cart.length,
      itemBuilder: (context, index) {
        return buildProductItem(cart![index]);
      },
    );
  }

  Widget buildProductItem(Cart cartItem) {
    // Thêm trạng thái isChecked
    void increaseQuantity() {
      if (cartItem.quantity > 0) {
        setState(() {
          totalMoney = 0.0;
          cartItem.quantity++; // Corrected this line
        });
        updateQuantity(cartItem.productId, cartItem.quantity);
      }
    }

    void decreaseQuantity() {
      if (cartItem.quantity > 0) {
        setState(() {
          totalMoney = 0.0;
          cartItem.quantity--;
        });
        updateQuantity(cartItem.productId, cartItem.quantity);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Xác nhận xóa sản phẩm"),
              content: Text("Bạn có chắc chắn muốn xóa sản phẩm này không?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Đóng dialog
                  },
                  child: Text("Hủy"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // Đóng dialog
                    await deleteCart(cartItem.productId);
                    // ...
                  },
                  child: Text("Đồng ý"),
                ),
              ],
            );
          },
        );
      }
    }

    return Column(
      children: [
        Divider(thickness: 1, color: Colors.grey),
        ListTile(
          contentPadding: EdgeInsets.all(8),
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    cartItem.isSelected = !cartItem.isSelected;
                    updateTotalMoney();
                  });
                },
                child: Container(
                  height: 30,
                  width: 30,
                  // margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                    color: cartItem.isSelected ? Colors.green : Colors.white,
                  ),
                  child: Center(
                    child: cartItem.isSelected
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 210, 157, 157)),
                  image: DecorationImage(
                    image: NetworkImage(
                      'http://localhost:9091/api/v1/product/fileSystem/${cartItem.img}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 50,
                    width: 70,
                    margin: EdgeInsets.only(top: 5, left: 5),
                    child: Text(
                      "Product: ${cartItem.productName}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 70,
                    margin: EdgeInsets.only(top: 5, left: 5),
                    child: Text(
                      "price: ${cartItem.price.toString()}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    child: IconButton(
                      onPressed: () {
                        increaseQuantity();
                      },
                      icon: Icon(Icons.add),
                    ),
                  ),
                  Container(
                    child: Text(
                      cartItem.quantity.toString(),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    child: IconButton(
                      onPressed: () {
                        decreaseQuantity();
                      },
                      icon: Icon(Icons.remove),
                    ),
                  ),
                ],
              ),
              Container(
                height: 50,
                width: 50,
                child: Center(
                  child: IconButton(
                    onPressed: () async {
                      await deleteCart(cartItem.productId);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container ShopName() {
    return Container(
      height: 50,
      width: 450,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Container(
        margin: EdgeInsets.only(left: 20, top: 10),
        child: GestureDetector(
          onTap: () {},
          child: Text(
            "SHOPNAME",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
