class Discount {
  int? id;
  String? code;
  double? discountValue;

  String? status;

  Discount({
    this.id,
    this.code,
    this.discountValue,
    this.status,
  });

  // Custom map method
  Discount map(dynamic Function(Discount) callback) {
    return callback(this);
  }

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'],
      code: json['code'],
      discountValue: json['discountValue'],
      status: json['status'],
    );
  }
  @override
  String toString() {
    return 'Discount{id: $id, code: $code, discountValue: $discountValue, status: $status}';
  }
}
