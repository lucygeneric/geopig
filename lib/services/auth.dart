import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:geopig/models/event.dart';
import 'package:geopig/models/site.dart';
import 'package:geopig/redux/actions/auth.dart';
import 'package:geopig/redux/actions/interface.dart';
import 'package:geopig/redux/store.dart';
import 'package:geopig/models/user.dart' as u;

enum AuthenticatorState {
  IDLE,
  DIGITS_VERIFYING,
  DIGITS_VERIFIED,
  FAILED,
  CODE_SENT,
  CODE_TIMEOUT,
  CODE_VERIFYING,
  AUTHENTICATED,
  HELP,
  HELP_RESTART
}
class AuthenticationService {

  static User get user {
    return FirebaseAuth.instance.currentUser;
  }

  static bool get loggedIn => user != null;

  static logout() async {
    await u.User.db.destroyAll();
    await Event.db.destroyAll();
    await Site.db.destroyAll();
    FirebaseAuth.instance.signOut();
  }

  final VoidCallback stateChangeCallback;

  AuthenticationService({this.stateChangeCallback});

  AuthCredential phoneAuthCredential;
  String verificationId;
  String fullNumber;
  int resendCodeToken;
  bool codeSent = false;
  bool authenticated = false;
  bool codeValid = true; // assume true until they fuck it up

  verifyNumber(String number, { int forceResendingToken }) {

    fullNumber = number;

    if (forceResendingToken == null)
      store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.DIGITS_VERIFYING));

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: Duration(seconds: 100),
      forceResendingToken: forceResendingToken,
      verificationCompleted: (PhoneAuthCredential credential) {
        phoneAuthCredential = credential;
        print("----------- verifyNumber Returns true");

        if (forceResendingToken == null)
          store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.DIGITS_VERIFIED));
      },
      verificationFailed: (FirebaseAuthException e) {
        print("----------- unable to authenticate, $e");

        store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.FAILED));
      },
      codeSent: (String vId, int resendToken) {
        print("----------- code sent, $verificationId");
        verificationId = vId;
        resendCodeToken = resendToken;
        codeValid = true;
        store.dispatchFuture(UpdateAuthenticatorState(value: AuthenticatorState.CODE_SENT)).then((value) =>
          store.dispatchFuture(UpdateBusy(value: false))
        );
      },
      codeAutoRetrievalTimeout: (String vId) {
        print("----------- code timeout, $verificationId");
        verificationId = vId;
        // timeout is relentless.. don't update state if we are in these other states
        if (!authenticated && codeValid)
          store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.CODE_TIMEOUT));
      }
    );
  }

  void resendCode(String number){
    verifyNumber(number, forceResendingToken: resendCodeToken);
  }

  void verificationCompleted(AuthCredential cred) {
    phoneAuthCredential = cred;
  }

  submitOTP(String smsCode) async {

    store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.CODE_VERIFYING));

    phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    try {
      await FirebaseAuth.instance
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential credential) {
            authenticated = true;
            store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.AUTHENTICATED));
          }).catchError((e) { return false; });
    } catch (e) {
      store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.FAILED));
      codeValid = false;
    }
  }

}