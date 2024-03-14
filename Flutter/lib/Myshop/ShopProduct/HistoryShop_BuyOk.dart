import 'package:flutter/material.dart';
import 'package:thaidui/Myshop/SeeShop.dart';
import 'package:thaidui/Service/Order_Details/Order_details.dart';
import 'package:thaidui/Service/ShopService/ShopService.dart';

class HistoryShopBuyOk extends StatefulWidget {
  const HistoryShopBuyOk({super.key});

  @override
  State<HistoryShopBuyOk> createState() => _HistoryShopBuyOkState();
}

List<OrderItem> orderItem = [];

class _HistoryShopBuyOkState extends State<HistoryShopBuyOk> {
  ShopService service = ShopService();

  Future<void> HistoryShopBuy() async {
    try {
      List<OrderItem>? order = await service.getHistoryShopOk();
      if (order!.isNotEmpty) {
        setState(() {
          orderItem = order;
        });
        return;
      }
      print("loi he thong HistoryShopBuy ");
    } catch (e) {
      print("lou he thong $e");
    }
  }

  @override
  void initState() {
    super.initState();
    HistoryShopBuy();
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SeeShop()));
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        title: Text('History Shop Buy Ok'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [buildHistoryBuyOK()],
        ),
      ),
    );
  }
}

Widget buildHistoryBuyOK() {
  if (orderItem.isEmpty) {
    return Center(
        child: Text(
      "History not data ",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ));
  }
  return ListView.builder(
    itemBuilder: (context, index) {
      return buildOrderItem(orderItem[index]);
    },
    itemCount: orderItem.length,
    shrinkWrap: true,
  );
}

Widget buildOrderItem(OrderItem order) {
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
                    height: 100,
                    width: 150,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 210, 157, 157)),
                      image: DecorationImage(
                        image: NetworkImage(
                          'http://localhost:9091/api/v1/product/fileSystem/${order.img}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: 50,
                        width: 120,
                        margin: EdgeInsets.only(top: 5, left: 10),
                        child: Text(
                          "Product: ${order.productName}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 120,
                        margin: EdgeInsets.only(top: 5, left: 10),
                        child: Text(
                          "Price: ${order.price.toString()}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  // Visibility(
                  //   visible: !checkTime(order!.order!.createOrder!),
                  //   child: Container(
                  //     height: 50,
                  //     width: 100,
                  //     decoration: BoxDecoration(
                  //       border: Border.all(width: 1, color: Colors.black),
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: const Color.fromARGB(255, 242, 115, 106),
                  //     ),
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         if (order.product!.id == null) {
                  //           print("null vl");
                  //         }
                  //         _showQuantityDialog(order.product!.id);
                  //       },
                  //       child: Center(child: Text("Refund Order")),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: Color.fromARGB(31, 235, 86, 86)),
              ),
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              width: 1, color: Color.fromARGB(31, 235, 86, 86)),
                        ),
                      ),
                      child: Center(
                        child: Text('Quantity: ${order.quantity.toString()}'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          '${order.order?.status == "SUCCESS" ? '✅' : ''}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 3),
              height: 2,
              color: Colors.black,
            ),
          ],
        ),
      ),
    ],
  );
}
