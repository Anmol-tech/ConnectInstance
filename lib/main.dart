import 'package:docker/Pages/BarHandler.dart';
import 'package:docker/Pages/HomePage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instant Connect',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(brightness: Brightness.dark),
      routes: {
        '/': (BuildContext context) => BarHandler(),
        '/home': (BuildContext context) => HomePage(),
      },
    );
  }
}
