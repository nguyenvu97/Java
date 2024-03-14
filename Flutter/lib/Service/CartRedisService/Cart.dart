import 'package:thaidui/Page/register.dart';

class Cart {
  final int productId;
  final double price;
  final String productName;
  int quantity;
  final int storeId;
  final String img;
  final String pathImg;
  bool isSelected;

  Cart(
      {required this.productId,
      required this.price,
      required this.productName,
      required this.quantity,
      required this.storeId,
      required this.img,
      required this.pathImg,
      this.isSelected = false});

  // Phương thức chuyển đổi từ Map sang đối tượng Product
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      productId: json['productId'],
      price: json['price'],
      productName: json['productName'],
      quantity: json['quantity'],
      storeId: json['storeId'],
      img: json['img'],
      pathImg: json['pathImg'],
    );
  }

  // Phương thức chuyển đổi thành Map
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'price': price,
      'productName': productName,
      'quantity': quantity,
      'storeId': storeId,
      'img': img,
      'pathImg': pathImg,
    };
  }

  // Phương thức toString
  @override
  String toString() {
    return 'Product{productId: $productId, price: $price, productName: $productName, quantity: $quantity, storeId: $storeId, img: $img, pathImg: $pathImg';
  }
}
