import 'package:flutter/material.dart';
import 'package:thaidui/Product/ProductDetails.dart';
import 'package:thaidui/Service/ProductService/ProductEntity.dart';
import 'package:thaidui/Service/ProductService/ProductService.dart';

class ProductPage extends StatefulWidget {
  final List<ProductEntity> productList;
  final String name;

  ProductPage({Key? key, required this.productList, required this.name})
      : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductService productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 20,
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(left: 200),
              //   child: IconButton(
              //     onPressed: () {},
              //     icon: Icon(Icons.more_horiz),
              //   ),
              // )
            ],
          ),
        ),
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
            if (widget.productList[index].id == null) {
              return Center(
                child: Text('not Product'),
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
                                print('Invalid index or productList is null');
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
    );
  }
}
