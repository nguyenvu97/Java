import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:thaidui/Service/Refound/Order_Refound.dart';
import 'package:thaidui/Service/Refound/Order_Refound_Service.dart';

class HistoryOrderRefoud extends StatefulWidget {
  const HistoryOrderRefoud({super.key});

  @override
  State<HistoryOrderRefoud> createState() => _HistoryOrderRefoudState();
}

class _HistoryOrderRefoudState extends State<HistoryOrderRefoud> {
  List<Order_Refound>? order_Refound;
  OrderRefoudService orderRefoudService = OrderRefoudService();
  Future<List<Order_Refound>?> getAllOrder_Refoun() async {
    try {
      List<Order_Refound>? orderRefound =
          await orderRefoudService.GetAllHistoryOrderRefoud();
      print("orderRefound $orderRefound");
      if (orderRefound != null) {
        print("orderRefound $orderRefound");
        setState(() {
          order_Refound = orderRefound;
        });
      }
      print(" loi $orderRefound");
    } catch (e) {
      print("loi he htong $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getAllOrder_Refoun();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical, child: buildOrder());
  }

  Widget buildOrder() {
    if (order_Refound == null) {
      // Trường hợp order là null, trả về một widget khác
      return Container(
        // height: 400,
        child: Center(
          child: Text(
            "You have not  Order Refound anything.",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: order_Refound!.length,
        itemBuilder: (context, index) {
          return buildOrderItem(order_Refound![index]);
        });
  }

  Widget buildOrderItem(Order_Refound order_refound) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Container(
                height: 110,
                width: 110,
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    image: DecorationImage(
                        image: NetworkImage(
                            'http://localhost:9091/api/v1/product/fileSystem/${order_refound.img}'))),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 50,
                    width: 120,
                    child: Text('ProductName : ${order_refound.productName}'),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 50,
                    width: 120,
                    child: Text('ProductName : ${order_refound.quantity}'),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 100,
                    margin: EdgeInsets.only(left: 10),
                    child: Text('Ly do : ${order_refound.reason}'),
                  ),
                  Container(
                    width: 100,
                    margin: EdgeInsets.only(left: 10),
                    child: Text('OrderNo : ${order_refound.orderNo}'),
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
          child: Row(children: [
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(width: 1, color: Colors.black))),
                  child: Center(
                      child: Text('Quantity :${order_refound.quantity}'))),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(width: 1, color: Colors.black))),
                  child: Center(
                      child: Text(
                          'refundMoney :${order_refound.refundMoney.toString()}'))),
            ),
            Expanded(
              child: Container(
                  child: Center(
                      child: Text('createUp :${order_refound.createUp}'))),
            ),
          ]),
        )
      ],
    );
  }
}
