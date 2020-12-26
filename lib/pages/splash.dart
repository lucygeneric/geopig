import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geopig/pages/dashboard/dashboard.dart';
import 'package:geopig/pages/login/login.dart';
import 'package:geopig/services/auth.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  // Splash also connects to firebase.  We need to wait for firebase to be ready.
  Future<void> initialRoute(BuildContext context) async {
    await Future<void>.microtask(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute<Login>(
          builder: (BuildContext context) {
            return AuthenticationService.loggedIn ? Dashboard() : Login();
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
        
        return Hero(
          tag: 'splashHero',
          child: Image.asset(
            'assets/logo.png',
          ));
      },
    );
  }
}