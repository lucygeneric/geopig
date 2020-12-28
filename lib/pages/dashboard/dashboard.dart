import 'package:flutter/material.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/services/auth.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(padding: EdgeInsets.all(kGutterWidth), child:
        Column(children: [
          Container(
            width: double.infinity,
            child: RaisedButton(child: Text('Site login'), onPressed: null)),
          Container(
            width: double.infinity,
            child: RaisedButton(child: Text('How to use this app'), onPressed: null)),
          Container(
            width: double.infinity,
            child: RaisedButton(child: Text('About location services'), onPressed: null)),
          Container(
            width: double.infinity,
            child: RaisedButton(child: Text('Logout'), onPressed: AuthenticationService.logout)),
        ])
      )
    );
  }


}