import 'package:flutter/material.dart';

class Text_Buton extends StatefulWidget {
  const Text_Buton(
      {super.key,
      required this.label,
      required this.icon,
      required this.Notifaition});
  final String label;
  final IconData icon;
  final VoidCallback Notifaition;

  @override
  State<Text_Buton> createState() => _TextButtonState();
}

class _TextButtonState extends State<Text_Buton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 430,
      child: Column(children: [
        Container(
          height: 50,
          width: 430,
          child: GestureDetector(
            onTap: widget.Notifaition,
            child: Row(
              children: [
                Container(
                  width: 50,
                  child: Icon(widget.icon),
                ),
                Container(
                  width: 150,
                  child: Text(widget.label),
                ),
                Container(
                  width: 100,
                  margin: EdgeInsets.only(left: 130),
                  child: Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
