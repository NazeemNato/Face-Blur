import 'package:face_blur/screen/homeScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Image Processing',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}