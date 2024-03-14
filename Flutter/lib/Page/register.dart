import 'package:flutter/material.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Service/UserService/User.dart';
import 'package:thaidui/Service/UserService/UserService.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _loginpageState();
}

class _loginpageState extends State<register> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _FullNameController = TextEditingController();
  TextEditingController _PhoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  void _onSignUpButtonPressed() async {
    // Kiểm tra xem số điện thoại chỉ chứa các ký tự số hay không
    bool isNumeric = RegExp(r'^[0-9]+$').hasMatch(_PhoneController.text);
    // Kiểm tra xem email có đúng định dạng hay không
    bool isValidEmail = RegExp(
      r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      caseSensitive: false,
    ).hasMatch(_emailController.text);
    // Kiểm tra xem fullname có được nhập hay không
    bool isFullNameNotEmpty = _FullNameController.text.isNotEmpty;

    // Kiểm tra điều kiện trước khi tạo đối tượng User
    if (isValidEmail &&
        _passwordController.text.isNotEmpty &&
        isFullNameNotEmpty &&
        isNumeric) {
      User user = User(
        email: _emailController.text,
        password: _passwordController.text,
        fullName: _FullNameController.text,
        phone: _PhoneController.text,
        address: _addressController.text,
      );

      bool signUpSuccess = await UserService().register(user);

      if (signUpSuccess) {
        // Handle successful registration
        final snackBar = SnackBar(
          content: Text('Đăng ký thành công!'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => loginpage()));
      } else {
        // Handle unsuccessful registration
        final snackBar = SnackBar(
          content: Text('Đăng ký không thành công. Vui lòng thử lại!'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      // Xử lý trường hợp người dùng không nhập đầy đủ thông tin hoặc thông tin không hợp lệ
      final snackBar = SnackBar(
        content: Text('Vui lòng nhập thông tin hợp lệ vào tất cả các trường!'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(30.0), // Đặt kích thước mong muốn tại đây
        child: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new))),
      ),
      body: RigisterContainer(context),
    );
  }

  Container RigisterContainer(BuildContext context) {
    return Container(
      width: 500,
      margin: EdgeInsets.only(top: 30),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 300,
            child: Image.asset('asset/image.jpeg'),
          ),
          Container(
            height: 70,
            width: 250,
            decoration: BoxDecoration(
                // color: Colors.white,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(45)),
            child: Center(
              child: Text(
                "REGISTER",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), // Đặt bán kính bo tròn
              color: Colors.white,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: 75,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    height: 75,
                    width: 300,
                    child: TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    height: 75,
                    child: TextField(
                      controller: _FullNameController,
                      decoration: InputDecoration(
                        labelText: 'Fullname',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    height: 75,
                    child: TextField(
                      controller: _PhoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    height: 75,
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
              height: 75,
              width: 150,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50)),
              child: GestureDetector(
                  onTap: () {
                    _onSignUpButtonPressed();
                  },
                  child: Center(
                    child: Text(
                      "Sigup",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ))),
        ],
      ),
    );
  }
}
