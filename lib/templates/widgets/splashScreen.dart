import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => Navigator.pushReplacementNamed(context, '/passerelle'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 220.0),
        child: Center(
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundImage: AssetImage('assets/logo.jpg'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
