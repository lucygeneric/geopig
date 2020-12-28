import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geopig/pages/login/login.dart';
import 'package:geopig/services/auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

enum AuthFlowState { IDLE, VERIFYING, INVALID_NUMBER, VALIDATING, INVALID_AUTH, COMPLETE }

class AuthenticatePage extends StatefulWidget {

  final Function(LoginFlowState) onComplete;

  AuthenticatePage({this.onComplete});

  @override
  _AuthenticatePageState createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage> {

  AuthFlowState state = AuthFlowState.IDLE;
  TextEditingController inputController = TextEditingController();

  Future validate() async {

    String fullNumber = await getPhoneNumber(inputController.text);

    AuthenticationService service = AuthenticationService();

    setState(() { state = AuthFlowState.VERIFYING; });
    bool validated = await service.verifyNumber(fullNumber);
    if (validated){
      setState((){ state = AuthFlowState.VALIDATING; });
    } else {
      setState((){ state = AuthFlowState.INVALID_NUMBER; });
    }

  }

  Future<String> getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'NZ');

    return number.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Center(child:
      Column(children: [
        InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber val) => print(val.phoneNumber),
          onSubmit: validate,
          textFieldController: inputController,
          inputDecoration: InputDecoration.collapsed(
            hintText: 'Enter yo phone num yo'
          ),
          countries: ["NZ"]
        ),
        SizedBox(height: 20),
        Text(state.toString()),
        SizedBox(height: 20),
        if (state == AuthFlowState.VERIFYING)
          Center(child: CircularProgressIndicator())
      ])

    );
  }
}