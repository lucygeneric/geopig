import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:geopig/pages/splash.dart';

Store<int> store;

void main() {
  store = Store<int>(initialState: 0);
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => StoreProvider<int>(
    store: store,
    child: MaterialApp(
      title: 'Geopig Slave Watchdog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),
    )
  );
}

