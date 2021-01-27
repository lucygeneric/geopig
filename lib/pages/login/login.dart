import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:async_redux/async_redux.dart' as Redux;
import 'package:geopig/pages/login/type_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geopig/color.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/services/auth.dart';
import 'package:geopig/type.dart';
import 'package:geopig/widgets/button.dart';
import 'package:geopig/widgets/input.dart';
import 'package:geopig/widgets/progress.dart';
import 'package:geopig/widgets/round_icon.dart';
import 'package:geopig/widgets/sms_code_input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';




abstract class LoginContentEnum {
  factory LoginContentEnum._() => null; // prevents extension.
  static const int INITIAL = 0;
  static const int CODE_ENTRY = 1;
  static const int CODE_TIMEOUT = 2;
  static const int AUTH_FAILED = 3;
  static const int COMPLETE = 4;
}
class _Login extends StatefulWidget {

  final AuthenticatorState authState;
  final int contentIndex;
  final int pageIndex;
  final String tagline;
  final String description;

  _Login({
    this.authState,
    this.contentIndex,
    this.pageIndex,
    this.tagline = "",
    this.description = ""
  });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<_Login> {

  double primaryContentOpacity = 0.0;
  double secondaryControlHeight = 0.0;
  Widget secondaryControlContent;
  TextEditingController inputController = TextEditingController();
  PageController pageController;
  AuthenticationService authService;
  bool phoneNumberIsValid = false;
  AuthenticatorState stateWas;

  @override
  void initState(){
    // setup
    authService = AuthenticationService();
    pageController = PageController(initialPage: 0);

    // startup
    checkAuth();
    super.initState();
  }

  void reset() async {
    primaryContentOpacity = 0.0;
    secondaryControlContent = null;
    this.secondaryControlHeight = 0.0;
  }

  void progress() async {
    setState(() { primaryContentOpacity = 0.0; });
    pageController.animateToPage(widget.pageIndex, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    await Future.delayed(Duration(milliseconds: 500));
    setState(() { primaryContentOpacity = 1.0; });
  }

  bool get controlsVisible => secondaryControlHeight != 0.0;

  Widget get resendControls => SizedBox(
    width: MediaQuery.of(context).size.width - (kGutterWidth * 2),
    child: SizedBox(height: 100, child: Flexible(child: Column(children: [
      Container(child: Text("Didn't get a code?", style: TextStyles.important(context))),
      Container(child: Text("It can take up to a minute to arrive ...", style: TextStyles.regular(context))),
      Button(label: "Send it again!")
  ]))));

  Widget get timeoutControls => SizedBox(
    width: MediaQuery.of(context).size.width - (kGutterWidth * 2),
    child: Column(children: [
      Container(child:
        Button(label: "Send a new code", onTap: authService.resendCode),
      ),
      Button(label: "You didn't send me a code!", color: PigColor.error)
  ]));

  Future checkAuth() async {
    FirebaseAuth.instance
      .authStateChanges()
      .listen((User user) {
        if (user != null)
          // navigate to dash CHECK IF THEY HAS A NAME THO
          print("Logged in....");
      });
  }

  Future validate() async {
    // TODO FIXME = CHECK NUMBER IS VALID
    if (phoneNumberIsValid == false){ print("PHONE NUMBER AINT VALID YO!!!!!!!! "); }
    String fullNumber = await getPhoneNumber(inputController.text);
    await authService.verifyNumber(fullNumber);
  }

  Future<String> getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'NZ');

    return number.phoneNumber;
  }

  void timeoutSecondaryControlReveal() async {
    if (secondaryControlContent == null || controlsVisible) return;

    await Future.delayed(Duration(milliseconds: 1500), () => print("Revealing..."));
    setState(() { this.secondaryControlHeight = 120.0; });
  }

  void addAdditionalControls(){
    // sometimes we have additional controls
    switch (widget.contentIndex){
      case LoginContentEnum.CODE_ENTRY:
        secondaryControlContent = resendControls;
        break;
      case LoginContentEnum.CODE_TIMEOUT:
        secondaryControlContent = timeoutControls;
        break;
      default:
        // do nowt
    }
    timeoutSecondaryControlReveal();
  }

  @override
  Widget build(BuildContext context) {

    // reset if state changed
    if (widget.authState != stateWas){
      reset();
      stateWas = widget.authState;
    }

    addAdditionalControls();

    // build the type array here
    List<String> typeText = [widget.tagline];
    if (widget.contentIndex == 0)
      typeText.insertAll(0, ['.','','.',]);

    print("BUILD IS CALLED AND PRIMARY CONTENT OPAICTY IS $primaryContentOpacity");

    return Scaffold(
      body: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        padding: EdgeInsets.all(kGutterWidth), child:

        Stack(children: [

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children:[
              // little dude
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(children: [
                  Spacer(),
                  SizedBox(height: 46, width: 46, child: SvgPicture.asset('assets/emoji_people.svg', fit: BoxFit.fill,))
                ])
              ),
              // Main 'hey' text
              Text("Hey.", style: TextStyles.headline(context)),
              // Tagline text
              PigTyperAnimatedTextKit(
                speed: Duration(milliseconds: 25),
                text: typeText,
                isRepeatingAnimation: false,
                textStyle: TextStyles.tagline(context),
                textAlign: TextAlign.start,
                onFinished: progress,
                //onRewind: reset
              ),
              // Description text
              SizedBox(height: 10),
              AnimatedOpacity(
                duration: Duration(milliseconds: 150),
                opacity: primaryContentOpacity,
                child:
                  Container(
                  height: 80, child:
                    Text(widget.description, style: TextStyles.regular(context)),
              )),

              Flexible(child:
                PageView(
                  controller: pageController,
                  children: [
                    /// IDX 0 - DIGITS/IDLE ------------------
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 250),
                          opacity: primaryContentOpacity,
                          child: Container(
                            decoration: BoxDecoration(
                              color: PigColor.interfaceGrey.withOpacity(0.5),
                              borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
                              border: Border.all(width: 1, color: PigColor.interfaceGrey)
                            ),
                            padding: EdgeInsets.all(kInputPadding),
                            child: Stack(
                              children: [
                                InternationalPhoneNumberInput(
                                  onInputChanged: (PhoneNumber val) => print(val.phoneNumber),
                                  onInputValidated: (bool val) => setState((){ phoneNumberIsValid = val; }),
                                  onSubmit: validate,
                                  textFieldController: inputController,
                                  inputDecoration: InputDecoration.collapsed(
                                    hintText: 'Tap to begin..'
                                  ),
                                  countries: ["NZ"]
                                ),

                                if (phoneNumberIsValid)
                                  Positioned(right: 0, child:
                                    RoundIcon(color: PigColor.primary, icon: Icons.done, size: Size(18,18))
                                  ),

                                if (!phoneNumberIsValid)
                                  Positioned(right: 0, child:
                                    RoundIcon(color: PigColor.warn, icon: Icons.phone_locked, size: Size(18,18))
                                  )
                              ])
                          ),
                        ),

                        if (widget.authState == AuthenticatorState.VERIFYING)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Searching for your digits...", style: TextStyles.important(context)),
                                Spacer(),
                                ProgressSpinner(size: 16.0),
                              ]
                            )

                          ),
                    ]),

                    /// IDX 1 - CODE ------------------
                    SmsCodeInput(

                    ),

                    /// IDX 2 - CODE TIMEOUT
                    Container(child:
                      Container(child: Text('timeout'))
                    ),

                    /// IDX 3 - CODE FAILED
                    Container(child:
                      Container(child: Text('failed'))
                    ),

                    /// IDX 4 - COMPLETE
                    Container(child: Text('complete'))
                  ]),
              )
            ]
          ),

          // Secondary Controls
          Positioned(bottom: 0, left:0, child:
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              height: secondaryControlHeight,
              child: secondaryControlContent
            )
          )
        ])

    ));
  }
}

/// REDUX VIEW MODEL /////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class LoginModel extends Redux.BaseModel<AppState> {
  LoginModel();

  AuthenticatorState authState;
  int contentIndex;
  int pageIndex;
  String tagline;
  String description;
  bool authStateChanged = false;

  // Taglines
  List<String> taglineContents = [
    "You seem new?",
    "You are new!",
    "Whoops!",
    "This is embarrasing..",
    "complete"
  ];

  // Descriptions
  List<String> descriptionContents = [
    "Type in your phone number and I will look to see if I have you in my database...",
    "I will send you a txt message with a unique code so that I can verify that you are really you. Enter this code below..",
    "It took too long for you to enter the code so I had to reset it, sorry about that.  Ask me for a new code!",
    "The RealClean login service is unreachable.\n\nCan you check that you are connected to the internet and try this again?",
    "complete"
  ];


  LoginModel.build({
    @required this.authState,
    @required this.contentIndex,
    @required this.pageIndex,
    @required this.tagline,
    @required this.description,
  }) : super(equals: [authState, contentIndex, pageIndex, tagline, description]);


  @override
  LoginModel fromStore() {

    int contentIndex;
    int pageIndex;

    switch(state.authState.state){
      case AuthenticatorState.IDLE:
      case AuthenticatorState.VERIFYING:
        contentIndex = LoginContentEnum.INITIAL;
        pageIndex = 0;
        break;
      case AuthenticatorState.VERIFIED:
      case AuthenticatorState.CODE_SENT:
        contentIndex = LoginContentEnum.CODE_ENTRY;
        pageIndex = 1;
        break;
      case AuthenticatorState.FAILED:
        contentIndex = LoginContentEnum.AUTH_FAILED;
        pageIndex = 2;
        break;
      case AuthenticatorState.CODE_TIMEOUT:
        contentIndex = LoginContentEnum.CODE_TIMEOUT;
        pageIndex = 1;
        break;
      case AuthenticatorState.VALIDATED:
        contentIndex = LoginContentEnum.COMPLETE;
        pageIndex = 3;
        break;
      default:
        contentIndex = LoginContentEnum.INITIAL;
        pageIndex = 0;
    }

    return LoginModel.build(
      authState: state.authState.state,
      contentIndex: contentIndex,
      pageIndex: pageIndex,
      tagline: taglineContents[contentIndex],
      description: descriptionContents[contentIndex]
    );
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Redux.StoreConnector<AppState, LoginModel>(
      model: LoginModel(),
      builder: (BuildContext context, LoginModel vm) => _Login(
        authState: vm.authState,
        tagline: vm.tagline,
        description: vm.description,
        contentIndex: vm.contentIndex,
        pageIndex: vm.pageIndex
      ),
    );
  }
}