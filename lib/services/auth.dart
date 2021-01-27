import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:geopig/redux/actions/auth.dart';
import 'package:geopig/redux/store.dart';

enum AuthenticatorState {
  IDLE,
  VERIFYING,
  VERIFIED,
  FAILED,
  CODE_SENT,
  CODE_TIMEOUT,
  VALIDATED
}
class AuthenticationService {

  static User get user {
    return FirebaseAuth.instance.currentUser;
  }

  static bool get loggedIn => user != null;

  static logout() => FirebaseAuth.instance.signOut();

  final VoidCallback stateChangeCallback;

  AuthenticationService({this.stateChangeCallback});

  AuthCredential phoneAuthCredential;
  String verificationId;
  bool codeSent = false;

  verifyNumber(String number, { bool isResend = false }) {
    store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.VERIFYING));
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: Duration(seconds: 5),
      verificationCompleted: (PhoneAuthCredential credential) {
        phoneAuthCredential = credential;
        print("----------- verifyNumber Returns true");
        if (!isResend)
          store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.VERIFIED));
      },
      verificationFailed: (FirebaseAuthException e) {
        print("----------- unable to authenticate, $e");
        store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.FAILED));
      },
      codeSent: (String vId, int resendToken) {
        print("----------- code sent, $verificationId");
        verificationId = vId;
        store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.CODE_SENT));
        // debug
        // submitOTP("123456");
      },
      codeAutoRetrievalTimeout: (String vId) {
        print("----------- code timeout, $verificationId");
        verificationId = vId;
        store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.CODE_TIMEOUT));
      },
    );
  }

  void resendCode(String number){
    verifyNumber(number, isResend: true);
  }

  void verificationCompleted(AuthCredential cred) {
    phoneAuthCredential = cred;
  }

  submitOTP(String smsCode) async {
    phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    try {
      await FirebaseAuth.instance
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential credential) {
            store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.VALIDATED));
          }).catchError((e) { return false; });
    } catch (e) {
      store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.FAILED));
    }
  }

}