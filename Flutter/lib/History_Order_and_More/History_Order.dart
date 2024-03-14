import 'package:flutter/material.dart';
import 'package:thaidui/History_Order_and_More/HIstory_order_Details.dart';
import 'package:thaidui/History_Order_and_More/NotPayMent_orderFail.dart';
import 'package:thaidui/History_Order_and_More/Order_Refoud_details.dart';
import 'package:thaidui/Service/HistoryService/HistoryOrder_Service.dart';
import 'package:thaidui/Service/Order_Details/Order_Details.dart';
import 'package:thaidui/Service/Order_Details/Order_Details_Service.dart';

class HistoryOrder extends StatefulWidget {
  const HistoryOrder({super.key});

  @override
  State<HistoryOrder> createState() => _HistoryOrderState();
}

class _HistoryOrderState extends State<HistoryOrder> {
  HistoryOrderService history = HistoryOrderService();

  OrderDetailsService orderDetailsService = OrderDetailsService();
  int _currentIndex = 0;

  List<Order>? order;

  Future<Order?> getAllOrderOk() async {
    try {
      List<Order>? order1 = await history.getHistory();
      if (order1 != null) {
        setState(() {
          order = order1;
        });
        print(order1);
      }
      print("order1 $order");
    } catch (e) {
      print("loi he thong $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getAllOrderOk();
  }

  @override
  Widget build(BuildContext context) {
    OrderDetailsService orderDetailsService = OrderDetailsService();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Method",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: Container(
            height: 50,
            width: 50,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios))),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          Row(
            children: [
              Expanded(
                child: buildTab('HistoryOrder', 0),
              ),
              Expanded(
                child: buildTab('Order Unpaid', 1),
              ),
              Expanded(
                child: buildTab('Order Refund', 2),
              ),
              Expanded(
                child: buildTab('Order Cancel', 3),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: getContentWidget(),
          )
        ]),
      ),
    );
  }

  Widget buildOrder() {
    if (order == null) {
      print(order);
      return Center(
        child: Text(
          "You have not ordered anything.",
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: order!.length,
        itemBuilder: (context, index) {
          return buildOrderItem(order![index]);
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
              child: order!.status == 'SUCCESS'
                  ? Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : null,
            ),
          ),
          Expanded(
              child: Container(
                  child: IconButton(
                      onPressed: () {
                        if (order.id == 0) {
                          Navigator.pop(context);
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryOrderDetails(
                                      orderNo: order?.orderNo ?? '',
                                    )));
                      },
                      icon: Icon(
                        Icons.history_toggle_off,
                        color: Colors.blue,
                      )))),
        ],
      ),
    );
  }

  Widget buildTab(String title, int index) {
    return InkWell(
      onTap: () {
        print("onTap index: $index");
        setState(() {
          _currentIndex = index;
          print(index);
        });
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Color.fromARGB(255, 225, 212, 212),
              width: 0.5,
              style: BorderStyle.solid,
            ),
            bottom: BorderSide(
              color: _currentIndex == index ? Colors.blue : Colors.white,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: _currentIndex == index ? Colors.red : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget getContentWidget() {
    print("_currentIndex in getContentWidget: $_currentIndex");
    return Builder(
      builder: (BuildContext context) {
        if (_currentIndex == 0) {
          return buildOrder();
        }
        if (_currentIndex == 1) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [Flexible(fit: FlexFit.loose, child: NotPayOrder())],
          );
        }
        if (_currentIndex == 2) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(fit: FlexFit.loose, child: HistoryOrderRefoud())
            ],
          );
        }
        if (_currentIndex == 3) {
          return Container(
            height: 50,
            width: 100,
            color: Colors.amberAccent,
          );
        }
        return buildOrder();
      },
    );
  }
}
