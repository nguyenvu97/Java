import 'package:flutter/material.dart';
import 'package:thaidui/Page/ForGetPassword/Input_OtpAnd_password.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Service/UserService/UserService.dart';

class forGetpassword extends StatefulWidget {
  String email;
  forGetpassword({super.key, required this.email});

  @override
  State<forGetpassword> createState() => _forGetpassWordState();
}

class _forGetpassWordState extends State<forGetpassword> {
  TextEditingController _emailController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _emailController.text = widget.email;
  }

  UserService userService = UserService();
  Future<bool?> checkEmail(String email) async {
    if (widget.email.length <= 0 && widget.email == null) {
      print('nhap email');
    }
    bool? data = await userService.forGetpassword(email);
    if (data == true) {
      return Navigator.push(context,
          MaterialPageRoute(builder: (context) => inputOtpAndPassword()));
    }
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Wrong Email '),
            content: Text('Please check your email '),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rest Password'),
        leading: Container(
          height: 50,
          width: 50,
          child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => loginpage()));
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 450,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://img.freepik.com/free-vector/forgot-password-concept-illustration_114360-1095.jpg'),
                    fit: BoxFit.cover)),
          ),
          InputEmail(widget.email),
        ],
      ),
    );
  }

  Column InputEmail(String email) {
    return Column(
      children: [
        Container(
          child: Container(
            margin: EdgeInsets.only(left: 70, right: 70, top: 20),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
            ),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(left: 100, right: 100, top: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.red,
              border: Border.all(width: 1)),
          child: TextButton(
            onPressed: () {
              checkEmail(_emailController.text);
            },
            child: Center(
              child: Text(
                "RESET",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }
}
