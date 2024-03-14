class OrderModel {
  int? productIds;
  int? quantities;
  double? shipMoney;
  String? phone;
  String? address;

  OrderModel(
      {this.productIds,
      this.quantities,
      this.shipMoney,
      this.phone,
      this.address});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productIds'] = this.productIds;
    data['quantities'] = this.quantities;
    data['shipMoney'] = this.shipMoney;
    return data;
  }
}
