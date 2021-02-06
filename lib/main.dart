import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geopig/pages/base.dart';
import 'package:geopig/pages/login/login.dart';
import 'package:geopig/pages/splash.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/redux/store.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => StoreProvider<AppState>(
    store: store,
    child: MaterialApp(
      title: 'Geolocation Watchdog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white
      ),
      initialRoute: '/',
      routes: {
        //'/': (context) => Dashboard(),
        '/login': (context) => Login(),
        '/base': (context) => Base(),
      },
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.black
        ),
        child: Splash()),
    )
  );
}

