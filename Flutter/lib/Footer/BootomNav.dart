import 'package:flutter/material.dart';
import 'package:thaidui/Cart/cart.dart';
import 'package:thaidui/Page/login.dart';
import 'package:thaidui/Profiles/Profiles.dart';
import 'package:thaidui/Video/Get_All_Video.dart';
import 'package:thaidui/page/home.dart';
import 'package:thaidui/page/register.dart';

class BottomNav extends StatefulWidget {
  final int currentIndex;

  const BottomNav({Key? key, required this.currentIndex}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (index == 0) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => homepage()));
        } else if (index == 1) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Profiles(),
          ));
        } else if (index == 2) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => loginpage()),
          );
        } else if (index == 3) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => GetallVideo()),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => loginpage()),
          );
        }
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login_outlined),
          label: "Notification",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_camera_back),
          label: "video",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: "More",
        ),
      ],
    );
  }
}
