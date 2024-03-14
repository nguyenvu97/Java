import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thaidui/Myshop/ShopProduct/ListProduct.dart';
import 'package:thaidui/Page/login.dart';

import 'package:thaidui/Service/ProductService/ProductEntity.dart';
import 'package:thaidui/Service/ShopService/ProductAdd.dart';
import 'package:thaidui/Service/ShopService/ShopService.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  int product = 1;
  String _filePath = '';
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
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _filePath = pickedImage.path;
      });
    }
  }

  ProductADD? productADD;
  final ShopService shopService = ShopService();
  Future<void> AddProduct_shop(ProductADD product, File image) async {
    try {
      var storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');
      if (token == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => loginpage()));
      }
      String? addproduct = await shopService.addProduct(token!, product, image);
      print(addproduct);
      // Handle the result accordingly
      if (addproduct != null && addproduct != '') {
        print(addproduct);
        print("ok");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListProdcut()));
      } else {
        print("Failed to add product, handle the error");
      }
    } catch (e) {
      print("loi j the $e");
    }
  }

  ProductADD convertToProductADD() {
    double price = double.tryParse(priceController.text) ?? 0.0;
    int quantity = int.tryParse(quantityController.text) ?? 0;
    print(price);
    print(quantity);

    return ProductADD(
        price: price,
        productName: productNameController.text,
        quantity:
            quantity, // Assuming _filePath is the image URL you want to use
        category: selectedValue!);
  }

  void addProduct() async {
    ProductADD productToAdd = convertToProductADD();
    File image = File(_filePath);
    print(image);
    await AddProduct_shop(productToAdd, image);
  }

  @override
  void initState() {
    super.initState();
  }

  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(30.0), // Đặt kích thước mong muốn tại đây
        child: AppBar(
            backgroundColor: Colors.white,
            title: Text("Add Product"),
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
          buildImageUploadField(),
          Container(
            width: 350,
            height: 70,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(width: 1, color: Colors.black)),
            child: ElevatedButton(
              onPressed: () {
                addProduct();
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
                  "Add Product",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                )
              ]),
            ),
          )
        ],
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

  Widget buildImageUploadField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: _pickImage, child: Text("Upload Image")),
      ],
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
}
