import 'package:flutter/material.dart';
import 'package:flutter_mountain_view/home_page.dart';

void main() {
  runApp(FlutterMountainView());
}

class FlutterMountainView extends StatelessWidget {
  const FlutterMountainView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
