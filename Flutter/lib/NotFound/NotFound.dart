import 'package:flutter/material.dart';
import 'package:thaidui/Page/home.dart';

class Notfond extends StatefulWidget {
  const Notfond({super.key});

  @override
  State<Notfond> createState() => _NotfondState();
}

class _NotfondState extends State<Notfond> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 350,
                width: 350,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("asset/notfond.jpg"))),
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 245, 198, 198)),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => homepage()));
                },
                child: Center(
                    child: Text(
                  "Go back to home",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ],
        ));
  }
}
