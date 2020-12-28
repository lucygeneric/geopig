import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/pages/login/authenticate.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

enum LoginFlowState {
  IDLE,
  VALIDATING,
  VERIFYING,
  UNREACHABLE,
  CODE_SENT,
  CODE_VALIDATING,
  CODE_FAILED,
  AUTHENTICATED
}
class _LoginState extends State<Login> {

  LoginFlowState state = LoginFlowState.IDLE;

  @override
  void initState(){
    checkAuth();
    super.initState();
  }

  Future checkAuth() async {
    FirebaseAuth.instance
      .authStateChanges()
      .listen((User user) {
        if (user == null) {
          setState((){ state = LoginFlowState.IDLE; });
        } else {
          setState((){ state = LoginFlowState.AUTHENTICATED; });
        }
      });
  }

  void updateLogin(LoginFlowState s) {
    if (s == LoginFlowState.AUTHENTICATED){
      Navigator.of(context).pushNamed("dashboard");
      return;
    }
    setState(() { state = s; });
  }

  Widget widgetFromState(){
    switch(state){
      case LoginFlowState.IDLE:
        return Center(child: CircularProgressIndicator());
      // case LoginFlowState.LOGGED_OUT:
      //   return AuthenticatePage(
      //     onComplete: (LoginFlowState state) => updateLogin(state)
      //   );
      default:
        return Container(child: Text("erm"));
    }
  }

  String get currentStateText {
    switch(state){
      case LoginFlowState.IDLE:
        return "Initializing..";
      default:
        return "Idk";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.all(kGutterWidth), child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
            Text("Current state: $currentStateText"),

            widgetFromState()
          ]
        )
    ));
  }
}