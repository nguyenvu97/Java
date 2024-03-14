class OrderItem {
  Product? product;
  Order? order;
  String? productName;
  double? price;
  int? quantity;
  int? storeId;
  double? totalMoney;
  double? shipMoney;
  int? userId;
  String? phone;
  String? address;
  String? img;

  OrderItem(
      {this.product,
      this.order,
      this.productName,
      this.price,
      this.quantity,
      this.storeId,
      this.totalMoney,
      this.shipMoney,
      this.userId,
      this.phone,
      this.address,
      this.img});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      product: Product.fromJson(json['product']),
      order: Order.fromJson(json['order']),
      productName: json['productName'],
      price: json['price'],
      quantity: json['quantity'],
      storeId: json['storeId'],
      totalMoney: json['totalMoney'],
      shipMoney: json['shipMoney'],
      userId: json['userId'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'order': order,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'storeId': storeId,
      'totalMoney': totalMoney,
      'shipMoney': shipMoney,
      'userId': userId,
      'img': img
    };
  }

  @override
  String toString() {
    return 'OrderItem{ product: $product, order: $order, productName: $productName, price: $price, quantity: $quantity, storeId: $storeId, totalMoney: $totalMoney, shipMoney: $shipMoney, userId: $userId}';
  }
}

/**
 * Order 
 */
class Order {
  int id;
  DateTime createOrder;
  String orderNo;
  double payment;
  String status;
  String phone;
  String email;
  String address; // Corrected spelling
  // double? money; // Add this property

  Order(
      {required this.id,
      required this.createOrder,
      required this.orderNo,
      required this.payment,
      required this.status,
      required this.phone,
      required this.email,
      required this.address});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['createOrder'] = this.createOrder?.toIso8601String();
    data['orderNo'] = this.orderNo;
    data['payment'] = this.payment;
    data['status'] = this.status;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    // data['money'] = this.money; // Include the 'money' property
    return data;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      createOrder: DateTime.parse(json['createOrder']),
      orderNo: json['orderNo'],
      payment: json['payment'],
      status: json['status'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      // money: json['money'],
    );
  }

  @override
  String toString() {
    return 'Order{id: $id, orderNo: $orderNo, payment: $payment, status: $status, phone: $phone, email: $email, address: $address,createAt: $createOrder}';
  }
}

/**
 * Product 
 */
class Product {
  int id;
  double price;
  String productName;
  int quantity;
  int storeId;
  DateTime createAt;
  DateTime updateAt;
  String img;
  String pathImg;
  String status;

  Product({
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

  @override
  String toString() {
    return 'Product{id: $id, price: $price, productName: $productName, quantity: $quantity, storeId: $storeId, createAt: $createAt, updateAt: $updateAt, img: $img, pathImg: $pathImg, status: $status}';
  }

  Map<String, dynamic> toMap() {
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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      price: json['price'],
      productName: json['productName'],
      quantity: json['quantity'],
      storeId: json['storeId'],
      createAt: DateTime.parse(json['createAt']),
      updateAt: DateTime.parse(json['updateAt']),
      img: json['img'],
      pathImg: json['pathImg'],
      status: json['status'],
    );
  }
}
