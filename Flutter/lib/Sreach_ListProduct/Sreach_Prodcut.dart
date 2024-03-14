import 'package:flutter/material.dart';
import 'package:thaidui/Myshop/SeeShop.dart';
import 'package:thaidui/Page/home.dart';
import 'package:thaidui/Product/ProductDetails.dart';
import 'package:thaidui/Service/ProductService/ProductEntity.dart';

class SreachListProduct extends StatefulWidget {
  List<ProductEntity> productList;
  SreachListProduct({super.key, required this.productList});

  @override
  State<SreachListProduct> createState() => _SreachListProductState();
}

class _SreachListProductState extends State<SreachListProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('List Product'),
          leading: Container(
              height: 50,
              width: 50,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => homepage()));
                  },
                  icon: Icon(Icons.arrow_back_ios))),
        ),
        body: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (widget.productList.length / 2).ceil(),
              itemBuilder: (context, index) {
                int startIndex = index * 2;
                int endIndex = startIndex + 2;
                if (endIndex > widget.productList.length) {
                  endIndex = widget.productList.length;
                }
                if (widget.productList.length == 0) {
                  return Container(
                    height: 100,
                    child: Text(
                      'product Not Found',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                // Tạo một dòng chứa 2 sản phẩm
                return Row(
                  children: [
                    for (int i = startIndex; i < endIndex; i++)
                      Container(
                        height: 200,
                        width: 200,
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 128,
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.productList[i].id != null &&
                                      0 < widget.productList.length) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetails(
                                          productID: widget.productList[i].id,
                                        ),
                                      ),
                                    );
                                    print(widget.productList[i].id);
                                  } else {
                                    print(
                                        'Invalid index or productList is null');
                                  }

                                  print(widget.productList[i].id);
                                },
                                child: Image.network(
                                    'http://localhost:9091/api/v1/product/fileSystem/${widget.productList[i].img}'),
                              ),
                            ),
                            Container(
                              height: 35,
                              child: Text(
                                widget.productList[i].productName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              height: 35,
                              child: Text(
                                widget.productList[i].price.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ));
  }
}
