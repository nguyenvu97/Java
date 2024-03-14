import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thaidui/Myshop/ShopProduct/ListProduct.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Service/ShopService/ProductAdd.dart';
import 'package:thaidui/Service/ShopService/ShopService.dart';

class UpdateProductStore extends StatefulWidget {
  int productID;
  UpdateProductStore({super.key, required this.productID});

  @override
  State<UpdateProductStore> createState() => _UpdateProductStoreState();
}

final List<String> items = [
  "day",
  "clothing",
  "food",
  "medicine",
  "phone",
  "watch",
  "cosmetics",
  "health",
];
String? selectedValue;

TextEditingController productNameController = TextEditingController();
TextEditingController quantityController = TextEditingController();
TextEditingController priceController = TextEditingController();

class _UpdateProductStoreState extends State<UpdateProductStore> {
  ProductADD? product2;
  final ShopService shopService = ShopService();
  Future<ProductADD?> updateProduct(ProductADD productADD) async {
    checkToken();
    try {
      ProductADD? product1 =
          await shopService.updateProductForShop(widget.productID, productADD);
      if (product1 != null) {
        setState(() {
          product2 = product1;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListProdcut()));
      }
    } catch (e) {
      print("loi he thong $e");
    }
  }

  void checkToken() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => loginpage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(30.0), // Đặt kích thước mong muốn tại đây
        child: AppBar(
            backgroundColor: Colors.white,
            title: Text("Update Product"),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new))),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 350,
            width: 350,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://cdni.iconscout.com/illustration/premium/thumb/woman-adding-product-to-cart-4268110-3550574.png'),
                    fit: BoxFit.cover)),
          ),
          buildTextField("Product Name", productNameController),
          buildTextField("Quantity", quantityController),
          buildTextField("Price", priceController),
          buildCategory(),
          Container(
            width: 350,
            height: 70,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(width: 1, color: Colors.black)),
            child: ElevatedButton(
              onPressed: () {
                String productname = productNameController.text;
                double price = double.parse(priceController.text);
                int quantity = int.parse(quantityController.text);
                updateProduct(ProductADD(
                    price: price,
                    productName: productname,
                    category: selectedValue!,
                    quantity: quantity));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  Icons.add_box,
                  color: Colors.black,
                ),
                Text(
                  "Update Product",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCategory() {
    return Container(
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
                  'Chon ngang hang ',
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
            setState(() {
              selectedValue = value;
            });
          },
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
    );
  }

  Widget buildTextField(
      String hintText, TextEditingController? textController) {
    return Container(
      height: 50,
      width: 430,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.black12, width: 2)),
      child: TextField(
        controller: textController,
        style: TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.all(15),
          border: InputBorder.none,
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(40),
          //   borderSide: BorderSide(color: Colors.blue, width: 2),
          // ),
        ),
      ),
    );
  }
}
