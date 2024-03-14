class Store {
  final int id;
  final String shopName;
  final String shopAddress;
  final String shopPhone;
  final String shopEmail;
  final double storeMoney;
  String? image;
  String? pathImage;

  Store({
    required this.id,
    required this.shopName,
    required this.shopAddress,
    required this.shopPhone,
    required this.shopEmail,
    required this.storeMoney,
    this.image,
    this.pathImage,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      shopName: json['shopName'],
      shopAddress: json['shopAddress'],
      shopPhone: json['shopPhone'],
      shopEmail: json['shopEmail'],
      storeMoney: json['storeMoney'].toDouble(),
      image: json['image'] as String?,
      pathImage: json['pathImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopName': shopName,
      'shopAddress': shopAddress,
      'shopPhone': shopPhone,
      'shopEmail': shopEmail,
      'storeMoney': storeMoney,
      'image': image,
      'pathImage': pathImage,
    };
  }

  @override
  String toString() {
    return 'Store(id: $id, shopName: $shopName, shopAddress: $shopAddress, shopPhone: $shopPhone, shopEmail: $shopEmail, storeMoney: $storeMoney, image: $image, pathImage: $pathImage)';
  }
}
