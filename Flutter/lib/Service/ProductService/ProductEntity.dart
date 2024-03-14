class ProductEntity {
  final int id;
  final double price;
  final String productName;
  final int quantity;
  final int storeId;
  final DateTime createAt;
  final DateTime updateAt;
  String img; // Remove final
  final String pathImg;
  final String status;

  ProductEntity({
    required this.id,
    required this.price,
    required this.productName,
    required this.quantity,
    required this.storeId,
    required this.createAt,
    required this.updateAt,
    required this.img,
    required this.pathImg,
    required this.status,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'] as int,
      price: json['price'] as double,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      storeId: json['storeId'] as int,
      createAt: DateTime.parse(json['createAt'] as String),
      updateAt: DateTime.parse(json['updateAt'] as String),
      img: json['img'] as String,
      pathImg: json['pathImg'] as String,
      status: json['status'] as String,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, price: $price, productName: $productName, quantity: $quantity, '
        'storeId: $storeId, createAt: $createAt, updateAt: $updateAt, img: $img, pathImg: $pathImg, '
        'status: $status}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'productName': productName,
      'quantity': quantity,
      'storeId': storeId,
      'createAt': createAt.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
      'img': img,
      'pathImg': pathImg,
      'status': status,
    };
  }
}
