import 'dart:ffi';

class MemberData {
  int id;
  int storeId;
  String sub;
  String phone;
  String address;
  int iat;
  int exp;
  String shopStatus;
  double money;

  MemberData({
    required this.id,
    required this.storeId,
    required this.sub,
    required this.iat,
    required this.exp,
    required this.shopStatus,
    required this.money,
    required this.address,
    required this.phone,
  });

  // Factory constructor để tạo một đối tượng từ một Map
  factory MemberData.fromJson(Map<String, dynamic> json) {
    return MemberData(
      id: json['id'],
      storeId: json['storeId'],
      sub: json['sub'],
      phone: json['phone'],
      address: json['address'],
      iat: json['iat'],
      exp: json['exp'],
      shopStatus: json['shopStatus'],
      money: json['money'].toDouble(),
    );
  }
  @override
  String toString() {
    return 'MemberData{id: $id, storeId: $storeId, sub: $sub, phone: $phone, address: $address, iat: $iat, exp: $exp, shopStatus: $shopStatus, money: $money}';
  }
}
