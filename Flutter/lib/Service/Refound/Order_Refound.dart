class Order_Refound {
  int userId;
  int productId;
  int quantity;
  String productName;
  String orderNo;
  double refundMoney;
  DateTime createUp;
  String reason;
  String img;

  Order_Refound(
      {required this.orderNo,
      required this.quantity,
      required this.productId,
      required this.productName,
      required this.reason,
      required this.refundMoney,
      required this.userId,
      required this.createUp,
      required this.img});
  @override
  String toString() {
    return 'Order_Refound{'
        'userId: $userId, '
        'productId: $productId, '
        'quantity: $quantity, '
        'productName: $productName, '
        'orderNo: $orderNo, '
        'refundMoney: $refundMoney, '
        'createUp: $createUp, '
        'img: $img, '
        'reason: $reason}';
  }

  factory Order_Refound.fromJson(Map<String, dynamic> json) {
    return Order_Refound(
      userId: json['userId'] as int,
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
      productName: json['productName'] as String,
      orderNo: json['orderNo'] as String,
      refundMoney: json['refundMoney'] as double,
      createUp: DateTime.parse(json['createUp'] as String),
      reason: json['reason'] as String,
      img: json['img'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
      'productName': productName,
      'orderNo': orderNo,
      'refundMoney': refundMoney,
      'createUp': createUp.toIso8601String(),
      'reason': reason,
      'img': img,
    };
  }
}
