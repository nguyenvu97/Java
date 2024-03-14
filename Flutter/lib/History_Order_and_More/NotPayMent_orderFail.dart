import 'package:flutter/material.dart';
import 'package:thaidui/Page/home.dart';
import 'package:thaidui/Service/HistoryService/HistoryOrder_Service.dart';
import 'package:thaidui/Service/Order_Details/Order_Details.dart';
import 'package:thaidui/Service/Order_Details/Order_Details_Service.dart';

class NotPayOrder extends StatefulWidget {
  const NotPayOrder({super.key});

  @override
  State<NotPayOrder> createState() => _NotPayOrderState();
}

class _NotPayOrderState extends State<NotPayOrder> {
  OrderDetailsService payment = OrderDetailsService();
  HistoryOrderService history = HistoryOrderService();
  List<Order>? orDer;

  Future<Order?> ListOrderUnpaid() async {
    try {
      List<Order>? order1 = await history.listOrderAuth();
      if (order1 != null) {
        setState(() {
          order1 = orDer;
        });
      }
      print('loi null $order1');
    } catch (e) {
      print("loi he thong $e");
    }
  }

  @override
  void initState() {
    super.initState();
    ListOrderUnpaid();
  }

  OrderDetailsService orderDetailsService = OrderDetailsService();
  @override
  Widget build(BuildContext context) {
    return Container(child: buildOrder());
  }

  Widget buildOrder() {
    if (orDer == null) {
      return Container(
        child: Center(
          child: Text(
            "You have not Payment anything.",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: orDer!.length,
        itemBuilder: (context, index) {
          return buildOrderItem(orDer![index]);
        });
  }

  Widget buildOrderItem(Order order) {
    return Container(
      height: 70,
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
      child: Row(
        children: [
          Container(
            width: 50,
            margin: EdgeInsets.only(left: 10),
            child: Text("Id :${order!.id.toString()}"),
          ),
          Expanded(
            child: Container(
              child: Text("OrderNo :${order!.orderNo}"),
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 20),
            child: Text("tong tien:${order!.payment}"),
          )),
          Expanded(
            child: Container(
              child: order!.status == 'AUTH'
                  ? Icon(
                      Icons.close,
                      color: Colors.red,
                    )
                  : null,
            ),
          ),
          Expanded(
              child: Container(
            height: 50,
            width: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.black)),
            child: TextButton(
              onPressed: () {
                history.ChangeStautus(order?.orderNo ?? '');
              },
              child: const Text("Cancel"),
            ),
          )),
          SizedBox(
            width: 3,
          ),
          Expanded(
              child: Container(
            height: 50,
            width: 60,
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.black)),
            child: TextButton(
              onPressed: () {
                if (order.id == 0) {
                  Navigator.pop(context);
                }
                orderDetailsService.PaymentVnPay(order?.orderNo ?? '');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => homepage()));
              },
              child: const Text("Pay"),
            ),
          )),
        ],
      ),
    );
  }
}
