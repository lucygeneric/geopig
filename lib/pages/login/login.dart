import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/pages/login/authenticate.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

enum LoginFlowState { INITIALIZING, LOGGED_IN, LOGGED_OUT }
class _LoginState extends State<Login> {

  LoginFlowState state = LoginFlowState.INITIALIZING;

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
          setState((){ state = LoginFlowState.LOGGED_OUT; });
        } else {
          setState((){ state = LoginFlowState.LOGGED_IN; });
        }
      });
  }

  void updateLogin(LoginFlowState s) {
    if (s == LoginFlowState.LOGGED_IN){
      Navigator.of(context).pushNamed("dashboard");
      return;
    }
    setState(() { state = s; });
  }

  Widget widgetFromState(){
    switch(state){
      case LoginFlowState.INITIALIZING:
        return Center(child: CircularProgressIndicator());
      case LoginFlowState.LOGGED_OUT:
        return AuthenticatePage(
          onComplete: (LoginFlowState state) => updateLogin(state)
        );
      case LoginFlowState.LOGGED_IN:
        return Text("Logged in yo");
      default:
        return Container(child: Text("erm"));
    }
  }

  String get currentStateText {
    switch(state){
      case LoginFlowState.INITIALIZING:
        return "Initializing..";
      case LoginFlowState.LOGGED_OUT:
        return "Logged out / unauthed.";
      case LoginFlowState.LOGGED_IN:
        return "Logged in :D";
      default:
        return "Idk";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column( 
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Text("Current state: $currentStateText"),
          Padding(padding: EdgeInsets.all(kGutterWidth), child:
            widgetFromState())
        ]
      )
    );
  }
}