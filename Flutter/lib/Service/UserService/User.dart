class User {
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final String address;

  User({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'fullName': fullName,
      'phone': phone,
      'address': address
    };
  }
}
