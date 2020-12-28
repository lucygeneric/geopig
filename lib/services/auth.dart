import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {

  static User get user {
    return FirebaseAuth.instance.currentUser;
  }

  static bool get loggedIn => user != null;

  static logout() => FirebaseAuth.instance.signOut();

  AuthCredential phoneAuthCredential;
  String verificationId;

  Future<bool> verifyNumber(String number) {

    var completer = Completer<bool>();

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) {
        phoneAuthCredential = credential;
        print("----------- verifyNumber Returns true");
        completer.complete(true);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("----------- unable to authenticate, $e");
        completer.complete(false);
      },
      codeSent: (String vId, int resendToken) {
        print("----------- code sent, $verificationId");
        verificationId = vId;

        // debug
        submitOTP("123456");
      },
      codeAutoRetrievalTimeout: (String vId) {
        print("----------- code timeout, $verificationId");
        verificationId = vId;
      },
    );

    return completer.future;

  }

  void verificationCompleted(AuthCredential cred) {
    print('verificationCompleted');
    phoneAuthCredential = cred;
  }

  Future<bool> submitOTP(String smsCode) async {
    phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    try {
      await FirebaseAuth.instance
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential credential) {
            print("Shit it worked...");
            return true;
          }).catchError((e) { return false; });
    } catch (e) {
      print("massive hosebeast--------------------\n$e");
    }
    return false;
  }

}