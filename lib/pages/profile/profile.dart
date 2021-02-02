import 'package:flutter/material.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/redux/actions/auth.dart';
import 'package:geopig/services/auth.dart';
import 'package:geopig/redux/store.dart';
import 'package:geopig/widgets/bottom_bar.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.all(kGutterWidth), child:
        Column(children: [
          Container(
            width: double.infinity,
            child: RaisedButton(child: Text('Logout'), onPressed: (){
              AuthenticationService.logout();
              store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.IDLE));
              Navigator.of(context).pushNamed("/");
            }
            )),
        ])
      ),
      bottomNavigationBar: BottomBar(),
    );
  }


}