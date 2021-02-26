import 'dart:async';
import 'package:covidapps/screen/mapscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pagetransaction.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  Animation<double> animation;
  Animation<double> secondaryAnimation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, _fetchSessionAndNavigate);
  }
  //sharedPreferences start (getting token)
  _fetchSessionAndNavigate() {
    Navigator.pushReplacement(
        context,
        SlideRightRoute(page: HomeScreen()));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // splash main logo
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: new Text("Welcome",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )
              )
            ],
          ),
          // splash lower logo static
         new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset('assets/images/logo_country.png',color: Colors.white60,),
                new Text("COVID 19 COUNT",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
