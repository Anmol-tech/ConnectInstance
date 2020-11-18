import 'package:docker/Pages/HomePage.dart';
import 'package:docker/Pages/Status.dart';
import 'package:flutter/material.dart';

class Connect {
  bool isConnected = false;
}

class BarHandler extends StatefulWidget {
  @override
  _BarHandlerState createState() => _BarHandlerState();
}

class _BarHandlerState extends State<BarHandler> {
  int _bottomBarIndex = 0;
  var bodyScreen = [HomePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _bottomBarIndex,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: IconButton(
      //         icon: Icon(Icons.home),
      //         onPressed: () {
      //           setState(() {
      //             _bottomBarIndex = 0;
      //           });
      //         },
      //       ),
      //       label: "Home",
      //     ),
      //     //   BottomNavigationBarItem(
      //     //     icon: IconButton(
      //     //         icon: Icon(Icons.menu),
      //     //         onPressed: () {
      //     //           setState(() {
      //     //             _bottomBarIndex = 1;
      //     //           });
      //     //         }),
      //     //     label: "Status",
      //     //   ),
      //   ],
      // ),
      body: bodyScreen[_bottomBarIndex],
    );
  }
}
