// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class firstScreen extends StatefulWidget {
  

  @override
  State<firstScreen> createState() => _firstScreenState();
}

class _firstScreenState extends State<firstScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold( 
    body: Column(
      children: [
        Lottie.network("https://lottie.host/fc377deb-4e52-4012-8f4a-29932e0e7135/UbKVjLY022.json",
        controller:_controller ),
        Center(
          child: Text("TECHقصـ")),
      ],
    ),);
  }
}