import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geopig/pages/login.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  // Splash also connects to firebase

  @override
  Widget build(BuildContext context) {

    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) throw("Fucked up TODO FIXME");
        
        if (snapshot.connectionState == ConnectionState.done) return Login();
        
        return Container(color: Colors.red, child: Text("Loading firebase"));
      },
    );
  }
}