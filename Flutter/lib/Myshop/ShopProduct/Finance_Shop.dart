import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thaidui/Page/login.dart';

class Finance_shop extends StatefulWidget {
  const Finance_shop({super.key});

  @override
  State<Finance_shop> createState() => _Finance_shopState();
}

class _Finance_shopState extends State<Finance_shop> {
  void checkToken() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => loginpage()));
    }
  }

  TextEditingController amountController = TextEditingController();
  int money = 10000000;
  int _currentIndex = 0;
  final List<String> items = [
    "Nhập số tiền",
    '300.000',
    '500.000',
    '1.000.000',
    '1.500.000',
  ];
  String? selectedValue;
  String? enteredAmount;

  List<String> paymentMethods = ['VnPay', 'PayPal', 'ZaloPay'];
  String? selectedPaymentMethod;
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("nap tien"),
        elevation: 1,
        leading: Container(
          height: 30,
          width: 30,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: Column(
        children: [
          Container(
            height: screenSize.height * 0.2,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 0.5,
                    color: const Color.fromARGB(255, 214, 163, 163))),
            child: Column(children: [
              Container(
                height: screenSize.height * 0.2 / 2.6,
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Center(
                        child: Text(
                      "Tong tien cua shop",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                    Center(
                        child: Text(
                      money.toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
              ),
              Container(
                height: screenSize.height * 0.2 / 2,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                          top: BorderSide(
                              color: const Color.fromARGB(255, 244, 169, 169),
                              width: 0.5),
                          right: BorderSide(
                              color: const Color.fromARGB(255, 244, 169, 169),
                              width: 0.5),
                        )),
                        child: buildTab('Lich su giao dich', 0, Icons.history),
                      ),
                    ),
                    Expanded(
                      // child: buildTab('Rut tien', 1, Icons.payment),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                          top: BorderSide(
                              color: const Color.fromARGB(255, 244, 169, 169),
                              width: 0.5),
                          right: BorderSide(
                              color: const Color.fromARGB(255, 244, 169, 169),
                              width: 0.5),
                        )),
                        child: buildTab('Rut tien', 1, Icons.payment),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          Expanded(
            child: getContentWidget(),
          )
        ],
      ),
    );
  }

  GestureDetector buildTab(String title, int index, IconData icon) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: (Icon(icon)),
            ),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  color: _currentIndex == index ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getContentWidget() {
    if (_currentIndex == 0) {
      return Column(
        children: [History_Tran()],
      );
    }
    if (_currentIndex == 1) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              height: 1,
              color: Colors.amber,
            ),
            Payment(),
            buidMoney(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: GestureDetector(
            onTap: () {
              print("abc");
            },
            child: Container(
              width: 430,
              child: Container(
                height: 40,
                width: 300,
                color: Colors.red,
                child: Center(
                  child: Text(
                    "giao dich",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return History_Tran();
  }

  Widget History_Tran() {
    return Column(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.black, width: 0.5))),
          margin: EdgeInsets.only(left: 10, top: 15),
          child: Row(
            children: [
              Container(
                width: 50,
                margin: EdgeInsets.only(bottom: 25),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
                  child: Image.asset("asset/bagmoney.png"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("rut tien"), Text("date")],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 250, bottom: 25),
                child: Text("money"),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buidMoney() {
    return Column(
      children: [
        Container(
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
                      "Nhập số tiền",
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
                setState(
                  () {
                    selectedValue = value;
                    amountController.text = "";
                    enteredAmount = "";
                  },
                );
              },
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
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
        ),
        Container(
          height: 50,
          width: 430,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: amountController,
              onChanged: (value) {
                // Cập nhật giá trị số tiền khi người dùng nhập
                setState(() {
                  enteredAmount = value;
                });
              },
              decoration: InputDecoration(
                hintText:
                    (selectedValue == "" && selectedValue == "Nhập số tiền")
                        ? selectedValue
                        : 'Số tiền đã chọn: ',
                border: InputBorder.none,
                enabled: selectedValue == "Nhập số tiền",
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            (selectedValue != null && selectedValue != "Nhập số tiền")
                ? 'Giá trị được chọn: $selectedValue'
                : (enteredAmount != null)
                    ? 'Số tiền đã nhập: $enteredAmount'
                    : '',
          ),
        ),
        // In giá trị được chọn ra màn hình
      ],
    );
  }

  Widget Payment() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            margin: EdgeInsets.only(top: 10, left: 10),
            child: Text("chon ngan hang"),
          ),
          Container(
            height: 50,
            width: 430,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  paymentMethods.length,
                  (index) => Container(
                    width: 150,
                    child: RadioListTile(
                      title: Text(paymentMethods[index]),
                      value: paymentMethods[index],
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value as String?;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      // activeColor: Colors.red,
                      // tileColor: Colors.white,
                      fillColor: MaterialStateColor.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors
                              .red; // Màu sắc khi radio button không được chọn
                        }
                        return Colors
                            .yellow; // Để sử dụng màu mặc định khi không ở trạng thái selected
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
