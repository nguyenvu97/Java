import 'package:flutter/material.dart';
import 'package:thaidui/Page/ForGetPassword/ForGet_PassWord.dart';
import 'package:thaidui/Page/home.dart';
import 'package:thaidui/Page/register.dart';
import 'package:thaidui/Service/UserService/UserService.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  void _onLoginPressed() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    bool loginSuccess = await UserService().Login(email, password);

    // Check the result of the login and navigate accordingly
    if (loginSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => homepage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Please check your email and password.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => homepage()));
                  },
                  icon: Icon(Icons.arrow_back_ios_new))),
        ),
        body: LoginContianer(context));
  }

  Container LoginContianer(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 450,
            child: Image.asset('asset/image.jpeg'),
          ),
          Container(
              height: 50,
              width: 200,
              // decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(50),
              //     border: Border.all(color: Colors.black, width: 1)),
              child: const Center(
                child: Text(
                  "LOGIN",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
/* LOGIN  */
          Container(
            height: 250,
            width: 300,
            decoration: BoxDecoration(
              // Đặt bán kính bo tròn
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
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                    height: 70,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.black, width: 1)),
                    child: GestureDetector(
                      onTap: () {
                        _onLoginPressed();
                      },
                      child: const Center(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => forGetpassword(
                                email: _emailController.text.trim(),
                              )));
                    },
                    child: Text(
                      "For Get Password ? ",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
/* Register  */
                Expanded(
                    child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 60),
                      child: Text(
                        "if you not account ?",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => register()));
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
