import 'package:flutter/material.dart';
import 'package:thaidui/History_Order_and_More/History_Order.dart';
import 'package:thaidui/Service/HistoryService/HistoryOrder_Service.dart';
import 'package:thaidui/Service/Order_Details/Order_Details.dart';
import 'package:thaidui/Service/Refound/Order_Refound_Service.dart';

class HistoryOrderDetails extends StatefulWidget {
  String orderNo;
  HistoryOrderDetails({Key? key, required this.orderNo}) : super(key: key);

  @override
  State<HistoryOrderDetails> createState() => _HistoryOrderDetailsState();
}

class _HistoryOrderDetailsState extends State<HistoryOrderDetails> {
  HistoryOrderService history = HistoryOrderService();
  OrderRefoudService orderRefoudService = OrderRefoudService();
  List<OrderItem>? orderItems;
  List<String> listReason = [
    'Sản phẩm bị hỏng khi nhận',
    'Sai sản phẩm gửi đến',
    'Không hài lòng với chất lượng',
    'Muốn đổi size',
    'Không thích sản phẩm',
    'Lý do khác',
  ];
  String? selectedValue;

  Future<void> getHistoryOrderDetails() async {
    try {
      List<OrderItem>? fetchedOrderItems =
          await history.getHistoryOrderDetails(widget.orderNo);
      if (fetchedOrderItems != null) {
        print(fetchedOrderItems);
        setState(() {
          orderItems = fetchedOrderItems;
        });
      }
      print('Error: $fetchedOrderItems');
    } catch (e) {
      print("System error: $e");
    }
  }

  bool checkTime(DateTime orderCreate) {
    DateTime time = DateTime.now();
    int currentTimeMillis = time.millisecondsSinceEpoch;
    int orderCreateTimeMillis = orderCreate.microsecondsSinceEpoch;
    int timeLine = currentTimeMillis - orderCreateTimeMillis;
    double timeDifferenceMinutes = timeLine / (1000 * 60);
    return timeDifferenceMinutes <= 20;
  }

  @override
  void initState() {
    super.initState();
    getHistoryOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History Order Details : ${widget.orderNo}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: Container(
          height: 50,
          width: 50,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          buildOrderDetails(),
          buildInformationOrder(),
        ]),
      ),
    );
  }

  Widget buildOrderDetails() {
    if (orderItems == null) {
      // Trường hợp order là null, trả về một widget khác
      return Center(
        child: Text(
          "You have not ordered anything.",
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: orderItems!.length,
      itemBuilder: (context, index) {
        return buildOrderItem(orderItems![index]);
      },
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
                    Visibility(
                      visible: !checkTime(order!.order!.createOrder!),
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 242, 115, 106),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (order.product!.id == null) {
                              print("null vl");
                            }
                            _showQuantityDialog(order.product!.id);
                          },
                          child: Center(child: Text("Refund Order")),
                        ),
                      ),
                    ),
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
                                width: 1,
                                color: Color.fromARGB(31, 235, 86, 86)),
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

  Widget buildInformationOrder() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Icon(Icons.receipt),
                SizedBox(width: 5),
                Text(
                  "Chi tiet Hoa don",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: orderItems != null && orderItems!.isNotEmpty
                ? buildOrderInformation(orderItems![0])
                : Container(
                    // Handle the case when orderItems is null or empty
                    child: Text("No order details available."),
                  ),
          ),
          SizedBox(height: 5),
          Container(
            height: 5,
            color: Colors.black,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      Icon(Icons.note_outlined),
                      SizedBox(width: 5),
                      Text(
                        "thong tin van chuyen",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 150,
                      child: Text("Email", style: TextStyle(fontSize: 15)),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 150),
                      child: Text(orderItems?.first?.order?.email ?? '',
                          style: TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 150,
                      child: Text("Phone", style: TextStyle(fontSize: 15)),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 150),
                      child: Text(orderItems?.first?.order?.phone ?? '',
                          style: TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 150,
                      child: Text("Address", style: TextStyle(fontSize: 15)),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 150),
                      child: Text(orderItems?.first?.order?.address ?? '',
                          style: TextStyle(fontSize: 15)),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildOrderInformation(OrderItem order) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 150,
              child: Text("tien ship ", style: TextStyle(fontSize: 15)),
            ),
            Container(
              margin: EdgeInsets.only(left: 150),
              child: Text(
                "${(orderItems?.length ?? 0) * (order?.shipMoney ?? 0)}",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 150,
              child: Text("Product Money", style: TextStyle(fontSize: 15)),
            ),
            Container(
              margin: EdgeInsets.only(left: 150),
              child: Text(
                  "${(orderItems?.length ?? 0) * (order.price ?? 0) * (order?.quantity ?? 0)}",
                  style: TextStyle(fontSize: 15)),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 150,
              child: Text("disCount", style: TextStyle(fontSize: 15)),
            ),
            Container(
              margin: EdgeInsets.only(left: 150),
              child: Text(
                  "${(order?.order?.payment ?? 0) - (orderItems?.length ?? 0) * (order.price ?? 0) * (order?.quantity ?? 0)}",
                  style: TextStyle(fontSize: 15)),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 150,
              child: Text("PayMent", style: TextStyle(fontSize: 15)),
            ),
            Container(
              margin: EdgeInsets.only(left: 150),
              child: Text("${order?.order?.payment ?? 0}",
                  style: TextStyle(fontSize: 15)),
            ),
          ],
        ),
        // Thêm các thông tin khác tương tự tại đây
        SizedBox(height: 10), // Khoảng cách giữa các OrderItem
      ],
    );
  }

  void _showQuantityDialog(int productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Refund Reason'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue;
                  });
                },
                items: listReason.map((String reason) {
                  return DropdownMenuItem<String>(
                    value: reason,
                    child: Text(reason),
                  );
                }).toList(),
                hint: Text('Select a reason'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                orderRefoudService.orderRefoudProduct(
                  widget.orderNo,
                  productId,
                  selectedValue ?? '',
                );
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryOrder()));
              },
              child: Text('Refund Order'),
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
