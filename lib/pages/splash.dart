import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/pages/base.dart';
import 'package:geopig/pages/dashboard/dashboard.dart';
import 'package:geopig/pages/login/login.dart';
import 'package:geopig/services/auth.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {

  // NOTE - this was setup for animation but there was an issue with the future builder
  // and context... parked. There is some animation cruft sitting around waiting for
  // ressurection

  int instancedMS;
  double logoHeight = 150;
  int logoAnimationDuration = 200;

  @override
  void initState(){
    instancedMS = DateTime.now().millisecondsSinceEpoch;
    super.initState();
  }

  int get timeoutValue {
    DateTime now = DateTime.now();
    return min(now.millisecondsSinceEpoch - instancedMS, logoAnimationDuration);
  }

  // Splash also connects to firebase.  We need to wait for firebase to be ready.
  Future<void> initialRoute(BuildContext context) async {

    await Future.delayed(Duration(milliseconds: 2000));

    await Future<void>.microtask(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute<Login>(
          builder: (BuildContext context) {
            return AuthenticationService.loggedIn ? Base() : Login();
          }));
    });
}

  @override
  Widget build(BuildContext context) {

    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) throw("Fucked up TODO FIXME");

        if (snapshot.connectionState == ConnectionState.done)
          initialRoute(context);

        return Scaffold(
          body: Column(children:[
            SizedBox(height: 100),
            Container(
              padding: EdgeInsets.symmetric(horizontal: kGutterWidth),
              color: Colors.white, child:
                Image.asset(
                  'assets/pigo.png',
              )),
            Spacer(),
            Container(
              padding: EdgeInsets.only(bottom: kGutterWidth * 2),
              width: 75,
              child:
                Image.asset(
                  'assets/powered.png',
              )),
          ])
        );
      },
    );
  }
}