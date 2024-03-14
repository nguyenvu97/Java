import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thaidui/Cart/cart.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Recharge/%20recharge_account.dart';
import 'package:thaidui/Service/CartRedisService/Cart.dart';
import 'package:thaidui/Service/CartRedisService/Cart_Redis_Service.dart';
import 'package:thaidui/Service/DisCount/DisCountService.dart';
import 'package:thaidui/Service/HomeService/HomeService.dart';
import 'package:thaidui/Service/HomeService/MemberData.dart';
import 'package:thaidui/Service/Order_Details/OrderModel.dart';

import 'package:thaidui/Service/Order_Details/Order_Details.dart';
import 'package:thaidui/Service/Order_Details/Order_Details_Service.dart';
import 'package:thaidui/Service/Recharge/RechargeDto.dart';
import 'package:thaidui/page/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:thaidui/Service/DisCount/DisCount.dart';

class Checkout extends StatefulWidget {
  List<Cart> cart1;
  Checkout({super.key, required this.cart1});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  DateTime time = new DateTime.now();
  String email = '';
  String phoneNumber = '';
  String shippingAddress = '';
  String selectedPaymentMethod = 'VnPay';
  List<String> paymentMethods = ['VnPay', 'PayPal', 'Amount', 'ZaloPay'];
  String? selectedVoucher = '';

  double shipmoney = 15000;
  TextEditingController _PhoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  double totalMoney = 0.0;
  void checkToken() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => loginpage()));
      return null;
    }
  }

/**
 * 
 * disCount 
 */
  DisCountService disCountService = DisCountService();
  List<Discount>? discount;
  Future<Discount?> getAllDiscount() async {
    try {
      List<Discount>? dicount1 = await disCountService.getAllDiscount();
      print(dicount1);
      if (dicount1 != null) {
        setState(() {
          discount = dicount1;
        });
        print(dicount1);
      } else {
        print('loi he thong $discount');
      }
    } catch (e) {
      print("loi he thong discount $e");
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
    updateTotalMoney();
    ShipMOney1();
    SumOrder();
    getAllDiscount();
    nmoneyAndDiscount(discount);
    inputFortokenData();
  }
  /**
   * Check out amount or vnpay
   */

  OrderItem? orderitem1;
  OrderDetailsService orderDetailsService = OrderDetailsService();
  CartRedisService cartRedisService = CartRedisService();
  MemberData? memberData1;
  Future<OrderItem?> checkOut() async {
    MemberData? memberData = await homeService.DecodeToken();
    print(memberData);
    checkToken();
    List<int> productIds =
        widget.cart1.map((cartItem) => cartItem.productId).toList();
    List<int> quantities =
        widget.cart1.map((cartItem) => cartItem.quantity).toList();

    try {
      int? cartQuantity;
      for (int j = 0; j < quantities.length; j++) {
        cartQuantity = quantities[j];
      }
      OrderModel inputOrder = OrderModel(
          quantities: cartQuantity,
          shipMoney: shipmoney,
          phone: _PhoneController.text,
          address: _addressController.text);
      print("inputOrder: $inputOrder");

      List<OrderItem>? orderItems = await orderDetailsService
          .createOrderdetails(productIds, inputOrder, selectedVoucher);

      if (orderItems != null && orderItems.isNotEmpty) {
        setState(() {
          orderitem1 = orderItems[0];
        });
        if (selectedPaymentMethod == 'VnPay') {
          orderDetailsService.PaymentVnPay(orderitem1!.order!.orderNo);
        }
        if (selectedPaymentMethod == 'Amount') {
          double? money1 = orderitem1!.order!.payment;
          print("money1 $money1");
          print("memberData!.money + ${memberData!.money}");
          if (memberData!.money >= money1) {
            orderDetailsService.PayAmount(orderitem1!.order?.orderNo ?? '');
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Recharge_account()));
          }
        }

        print("Order Item: $orderitem1");
      } else {
        print("Failed to create order for product $productIds");
        // Xử lý lỗi tùy thuộc vào yêu cầu của bạn
      }
    } catch (e) {
      print("System error: $e");
    }

    return orderitem1;
  }

/**
 *  Use token cutomer not input phone anh adrress
 * 
 */
  HomeService homeService = HomeService();
  Future<MemberData?> inputFortokenData() async {
    try {
      MemberData? memberData = await homeService.DecodeToken();
      if (memberData != null) {
        setState(() {
          memberData1 = memberData;
          _PhoneController.text = memberData.phone ?? '';
          _addressController.text = memberData.address ?? '';
        });
        print("memberData1 + $memberData1");
      } else {
        print('loi decode token ');
      }
    } catch (e) {
      print('loi he thong $e');
    }
  }

  List<Cart>? cart;
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

  void updateTotalMoney() {
    for (Cart cartItem in widget.cart1) {
      if (cartItem.isSelected) {
        totalMoney += cartItem.price * cartItem.quantity;
      } else {
        totalMoney = 0.0;
      }
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

  double sumShipmoney = 0;
  double sumOrder = 0;
  void ShipMOney1() {
    int slproduct = widget.cart1.length;
    sumShipmoney = shipmoney * slproduct;
  }

  void SumOrder() {
    sumOrder = sumShipmoney + totalMoney;
  }

  double MoneyAfterDisount = 0;
  double? nmoneyAndDiscount(List<Discount>? discountList) {
    if (selectedVoucher == '' || discountList == null || discountList.isEmpty) {
      return MoneyAfterDisount;
    }

    for (Discount discountItem in discountList) {
      String? discountValueObj = discountItem!.discountValue.toString();
      if (discountValueObj is String) {
        double discountValue = double.parse(discountValueObj.toString() ?? '0');
        double discountPercentage = discountValue / 100.0;
        MoneyAfterDisount = sumOrder * discountPercentage;
        print(MoneyAfterDisount);
        return MoneyAfterDisount;
      }
    }

    return null; // Hoặc giá trị mặc định khác nếu không có discount hợp lệ.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          height: 30,
          width: 30,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        title: Text("Check Out"),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            buildCartList(),

            Column(
              children: [
                buildDiscount(),

                // shop voucher
                Container(
                  height: 0.5,
                  color: Color.fromARGB(255, 225, 212, 212),
                ),
                SumMoney(),
                // pay meath

                Payment(),
              ],
            ),
            Container(
              height: 5,
              color: Color.fromARGB(255, 225, 212, 212),
            ),

            // information order
            InfotionsOrder(),
            Container(
              height: 5,
              color: Color.fromARGB(255, 225, 212, 212),
            ),
            InputOrder(),
          ])),
    );
  }

  Padding InputOrder() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // TextField(
          //   decoration: InputDecoration(labelText: 'Email'),
          //   onChanged: (value) {
          //     setState(() {
          //       email = value;
          //     });
          //   },
          // ),
          TextField(
            controller: _PhoneController,
            decoration: InputDecoration(labelText: 'Phone Number'),
            onChanged: (value) {
              setState(() {
                phoneNumber = value;
              });
            },
          ),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Shipping Address'),
            onChanged: (value) {
              setState(() {
                shippingAddress = value;
              });
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              checkOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => homepage()));
              // if (paymentMethods.contains('vnpay')) {
              //   PaymentVnPay();
              //   _launchUrl(recharDto?.url ?? '');
              // }
            },
            child: Text('Place Order'),
          ),
        ],
      ),
    );
  }

  Widget InfotionsOrder() {
    return Container(
      width: 430,
      child: Column(
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Icon(Icons.receipt),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Chi tiet Hoa don",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child:
                      Text("tong tien hang  ", style: TextStyle(fontSize: 15)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 150),
                  child: Text(totalMoney.toString(),
                      style: TextStyle(fontSize: 15)),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child:
                      Text("phi van chuyen  ", style: TextStyle(fontSize: 15)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 150),
                  child: Text(sumShipmoney.toString(),
                      style: TextStyle(fontSize: 15)),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: Text(
                    "Voucher Giam gia",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 150),
                  child: Text(nmoneyAndDiscount(discount)?.toString() ?? '0',
                      style: TextStyle(fontSize: 15)),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Container(
                  child: Text(
                    "Tong Hoa don ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 100,
                  margin: EdgeInsets.only(left: 150),
                  child: Text(sumOrder.toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container Payment() {
    return Container(
      height: 50,
      width: 430,
      margin: EdgeInsets.only(left: 10),
      child: DropdownButton(
        value: selectedPaymentMethod,
        onChanged: (newValue) {
          setState(() {
            selectedPaymentMethod = newValue.toString();
          });
        },
        items: paymentMethods.map((method) {
          IconData icon;
          // Ánh xạ biểu tượng với từng phương thức thanh toán
          switch (method) {
            case 'VnPay':
              icon = Icons.card_membership;
              break;
            case 'PayPal':
              icon = Icons.payment;
              break;
            case 'Amount':
              icon = Icons.account_balance;
              break;
            default:
              icon = Icons.payment;
          }
          return DropdownMenuItem(
            value: method,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon),
                SizedBox(width: 5),
                Text(
                  method,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Container SumMoney() {
    return Container(
      height: 50,
      width: 430,
      child: Row(
        children: [
          Container(
              margin: EdgeInsets.only(left: 10),
              child: Icon(Icons.attach_money)),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Center(
              child: Text(
                "Sum money : ",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 100),
            width: 200,
            child: Center(child: Text(totalMoney.toString())),
          )
        ],
      ),
    );
  }

  Container Ship() {
    return Container(
      margin: EdgeInsets.all(10),
      height: 50,
      width: 380,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: const Color.fromARGB(255, 2, 131, 236), width: 0.5)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Van chuyen",
                    style: TextStyle(
                        fontSize: 15,
                        color: const Color.fromARGB(255, 2, 131, 236)),
                  )),
            ),
          ),
          Expanded(
            child: Container(
              width: 150,
              child: Center(
                child: Text("sieu toc "),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 150,
              child: Center(
                child: Text(shipmoney.toString()),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildProductItem(Cart cartItem) {
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
          title: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      height: 110,
                      width: 110,
                      margin: EdgeInsets.only(left: 10),
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
                          width: 100,
                          margin: EdgeInsets.only(top: 5, left: 5),
                          child: Text(
                            "Product: ${cartItem.productName}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 100,
                          margin: EdgeInsets.only(top: 5, left: 5),
                          child: Text(
                            "price: ${cartItem.price.toString()}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
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
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
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
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3),
                height: 2,
                color: Colors.black,
              ),
              Ship()
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCartList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.cart1!.length,
      itemBuilder: (context, index) {
        return buildProductItem(widget.cart1![index]);
      },
    );
  }

  Widget buildDiscount() {
    // if (discount == null || discount!.isEmpty) {
    //   return Text('Không có discount');
    // }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          discount != null ? discount!.length : 0,
          (index) => buildDiscountItem(discount![index]),
        ),
      ),
    );
  }

  Widget buildDiscountItem(Discount discountItem) {
    bool isSelected = selectedVoucher == discountItem.code;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedVoucher =
                isSelected ? selectedVoucher : discountItem.code ?? '';
          });
        },
        child: Container(
          height: 50,
          width: 150,
          decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.amber,
              borderRadius: BorderRadius.circular(10)),
          // Màu khi được chọn và không được chọn
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.card_giftcard),
              SizedBox(width: 5),
              Text(
                '${discountItem.code} - ${discountItem.discountValue}%',
                style: TextStyle(
                    fontSize: 15,
                    color: isSelected ? Colors.white : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
