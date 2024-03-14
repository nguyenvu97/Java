import 'package:flutter/material.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Service/UserService/UserService.dart';

class inputOtpAndPassword extends StatefulWidget {
  const inputOtpAndPassword({super.key});

  @override
  State<inputOtpAndPassword> createState() => _inputOtpAndPasswordState();
}

class _inputOtpAndPasswordState extends State<inputOtpAndPassword> {
  TextEditingController _otp = TextEditingController();
  TextEditingController _passWorld = TextEditingController();
  UserService userService = UserService();
  void inputdata() {
    String otpInput = _otp.text.trim();
    String passwordInput = _passWorld.text.trim();

    if (otpInput.isEmpty || passwordInput.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Missing Information'),
            content: Text('Please input both Password and OTP.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Ok"),
              ),
            ],
          );
        },
      );
    } else {
      try {
        int otp = int.parse(otpInput);
        Future<String?> abc =
            userService.inputOtpAndPassword(otp, passwordInput);

        abc.then((result) {
          if (result != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => loginpage()),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Incorrect OTP or Expired OTP'),
                  content: Text('Please verify your OTP or request a new one.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Ok"),
                    ),
                  ],
                );
              },
            );
          }
        });
      } catch (e) {
        // Handle the case where OTP is not a valid integer
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid OTP'),
              content: Text('Please enter a valid OTP.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Otp And Password'),
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
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 450,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: DecorationImage(
                    image: NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/009/387/014/non_2x/otp-authentication-and-secure-verification-never-share-otp-and-bank-details-concept-vector.jpg'),
                    fit: BoxFit.cover)),
          ),
          Column(
            children: [
              Container(
                child: Container(
                  margin: EdgeInsets.only(left: 120, right: 120, top: 20),
                  child: TextField(
                    controller: _otp,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'OTP',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Container(
                  margin: EdgeInsets.only(left: 70, right: 70, top: 20),
                  child: TextField(
                    controller: _passWorld,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'NewPassword',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ]),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            margin: EdgeInsets.only(left: 50, right: 50),
            decoration:
                BoxDecoration(color: Colors.red, border: Border.all(width: 1)),
            child: TextButton(
              onPressed: () {
                inputdata();
              },
              child: Text(
                'Change Password',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ));
  }
}
