import 'package:flutter/material.dart';

class CreateIconButton extends StatefulWidget {
  const CreateIconButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.ontap});
  final String label;
  final IconData icon;
  final VoidCallback ontap;

  @override
  State<CreateIconButton> createState() => _createIconButtonState();
}

class _createIconButtonState extends State<CreateIconButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: GestureDetector(
              onTap: widget.ontap,
              child: Center(
                child: Icon(
                  widget.icon,
                  size: 40,
                  color: Color.fromARGB(255, 239, 98, 98),
                ),
              )),
        ),
        Center(
          child: Container(
            // margin: EdgeInsets.only(left: 10),
            child: Text(
              widget.label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
