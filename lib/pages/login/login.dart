import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:async_redux/async_redux.dart' as Redux;
import 'package:confetti/confetti.dart';
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
import 'package:geopig/widgets/progress.dart';
import 'package:geopig/widgets/round_icon.dart';
import 'package:geopig/widgets/sms_code_input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';


class _Login extends StatefulWidget {

  final AuthenticatorState authState;
  final int pageIndex;
  final String tagline;
  final String description;

  _Login({
    this.authState,
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
  String taglineWas;
  ConfettiController confettiController;


  @override
  void initState(){
    // setup
    authService = AuthenticationService();
    pageController = PageController(initialPage: 0);
    confettiController = ConfettiController(duration: const Duration(milliseconds: 1500));

    // startup
    checkAuth();
    super.initState();
  }

  @override
  void dispose() {
    confettiController?.dispose();
    super.dispose();
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
    height: secondaryControlHeight,
    child: Column(children: [
      Container(child: Text("Didn't get a code?", style: TextStyles.important(context))),
      Container(child: Text("It can take up to a minute to arrive ...", style: TextStyles.regular(context))),
      Button(label: "Send it again!", onTap: resendCode)
  ]));

  Widget get timeoutControls => SizedBox(
    width: MediaQuery.of(context).size.width - (kGutterWidth * 2),
    height: secondaryControlHeight,
    child: Column(children: [
      Container(child:
        Button(label: "Send a new code", onTap: resendCode)
      ),
      Button(label: "You didn't send me a code!", color: PigColor.error)
  ]));

  Widget get failedControls => SizedBox(
    width: MediaQuery.of(context).size.width - (kGutterWidth * 2),
    height: secondaryControlHeight,
    child: Column(children: [
      Container(child: Text("Hate it when that happens.", style: TextStyles.important(context))),
      Container(child: Text("I am going to send you a totally different code so you can approach this from a fresh angle..", style: TextStyles.regular(context))),
      Container(child:
        Button(label: "Send another code", onTap: resendCode)
      ),
  ]));

  Future checkAuth() async {
    FirebaseAuth.instance
      .authStateChanges()
      .listen((User user) {
        if (user != null){
          // navigate to dash CHECK IF THEY HAS A NAME THO
          print("----------------------- LOGGED IN STATE ------------------------------");

        }
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

  void resendCode() async {
    String fullNumber = await getPhoneNumber(inputController.text);
    authService.resendCode(fullNumber);
  }

  void timeoutSecondaryControlReveal() async {
    // make sure the panel is hidden if the content is awol
    if (secondaryControlContent == null){
      this.secondaryControlHeight = 0.0;
      return;
    }
    // don't do this if they are already visible
    if (controlsVisible) return;

    await Future.delayed(Duration(milliseconds: 1500), () => print("[INFO] Revealing Secondary Controls"));
    setState(() { this.secondaryControlHeight = 130.0; });
  }

  void addAdditionalControls(){
    // sometimes we have additional controls.  There are rules for when to show them
    secondaryControlContent = null;

    /// ADDITIVE
    // if we are on code entry
    if (widget.pageIndex == PageEnum.CODE_ENTRY.index)
      secondaryControlContent = resendControls;

    // if we are on code timeout
    if (widget.pageIndex == PageEnum.CODE_TIMEOUT.index)
      secondaryControlContent = timeoutControls;

    // if they got it wrong...
    if (widget.pageIndex == PageEnum.ERROR.index)
      secondaryControlContent = failedControls;

    /// SUBTRACTIVE
    // if it's verifying then don't show the controls
    if (widget.authState == AuthenticatorState.CODE_VERIFYING)
      secondaryControlContent = null;

    timeoutSecondaryControlReveal();
  }

  Widget loadingWidget(){
    if ([AuthenticatorState.DIGITS_VERIFYING, AuthenticatorState.CODE_VERIFYING].contains(widget.authState))
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(widget.authState == AuthenticatorState.DIGITS_VERIFYING ? "Searching for your digits..." : "Doing a thing...", style: TextStyles.important(context)),
            Spacer(),
            ProgressSpinner(size: 16.0),
          ]
        )

      );
    return Container();
  }

  @override
  Widget build(BuildContext context) {

    // reset if tagline changed because it means the
    // text items need to regenerate
    if (widget.tagline != taglineWas){
      reset();
      taglineWas = widget.tagline;
    }

    addAdditionalControls();

    // build the type array here
    List<String> typeText = [widget.tagline];
    // add a little lead-in
    if (widget.pageIndex == 0)
      typeText.insertAll(0, ['.','','.',]);

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

                  Expanded(child:
                  AnimatedOpacity(
                duration: Duration(milliseconds: 150),
                opacity: primaryContentOpacity,
                child:
                    PageView(
                      controller: pageController,
                      children: [
                        /// IDX 0 - DIGITS/IDLE ------------------
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
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

                            loadingWidget(),

                        ]),

                        /// IDX 1 - CODE ------------------
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SmsCodeInput(
                              enabled: [PageEnum.CODE_ENTRY.index,PageEnum.CODE_TIMEOUT.index].contains(widget.pageIndex),
                              onFinished: (String code) => authService.submitOTP(code),
                            ),
                            loadingWidget()
                          ]),

                        /// IDX 2 - CODE TIMEOUT
                        Container(child:
                          Container()
                        ),

                        /// IDX 3 - CODE COMPLETE
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ConfettiWidget(
                              confettiController: confettiController,
                              blastDirectionality: BlastDirectionality.explosive,
                              shouldLoop: true,
                              colors: const [
                                PigColor.interfaceGrey,
                                PigColor.primary
                              ], // manually specify the colors to be used
                            ),
                            SizedBox(height: 60, child:
                              Button(label: "GO!", onTap: () => Navigator.of(context).pushReplacementNamed("/dashboard")))
                          ]
                        ),

                        /// IDX 4 - ERROR
                        Container()
                      ]),
                  ),
              ),

              SingleChildScrollView(child:
                // this thing overflows. problem for another day.
                AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  height: secondaryControlHeight,
                  child: secondaryControlContent
                )
              )
            ]
          ),

          // Secondary Controls


        ])

    ));
  }
}

/// REDUX VIEW MODEL /////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
///
enum PageEnum {
  INITIAL, CODE_ENTRY, CODE_TIMEOUT, COMPLETE, ERROR
}
class LoginModel extends Redux.BaseModel<AppState> {
  LoginModel();

  AuthenticatorState authState;
  int pageIndex;
  String tagline;
  String description;
  bool authStateChanged = false;

  // Taglines
  List<String> taglineContents = [
    "Do I know you?",
    "Eyeballing...",
    "Whoops...",
    "Thanks!",
    "Uh Oh..."
  ];

  // Descriptions
  List<String> descriptionContents = [
    "Type in your phone number and I will look to see if I have you in my database...",
    "I have sent you a txt message with a unique code so that I can verify that you are really you. Enter this code below..",
    "It took too long for you to enter the code so I had to reset it, sorry about that.  Ask me for a new code!",
    "We are now connected! Good things await inside, lets get started!",
    "The code you entered looks strange to me... are you sure you are really a person?"
  ];


  LoginModel.build({
    @required this.authState,
    @required this.pageIndex,
    @required this.tagline,
    @required this.description,
  }) : super(equals: [authState, pageIndex, tagline, description]);


  @override
  LoginModel fromStore() {


    int pageIndex;
    print("----------------------- state.authState.state ${state.authState.state}");
    switch(state.authState.state){
      case AuthenticatorState.IDLE:
      case AuthenticatorState.DIGITS_VERIFYING:
        pageIndex = PageEnum.INITIAL.index;
        break;
      case AuthenticatorState.DIGITS_VERIFIED:
      case AuthenticatorState.CODE_SENT:
        pageIndex = PageEnum.CODE_ENTRY.index;
        break;
      case AuthenticatorState.FAILED:
        pageIndex = PageEnum.ERROR.index;
        break;
      case AuthenticatorState.CODE_TIMEOUT:
        pageIndex = PageEnum.CODE_TIMEOUT.index;
        break;
      case AuthenticatorState.CODE_VERIFYING:
        // no custom content, it's just verifying again...
        pageIndex = PageEnum.CODE_ENTRY.index;
        break;
      case AuthenticatorState.AUTHENTICATED:
        pageIndex = PageEnum.COMPLETE.index;
        break;
      default:
        pageIndex = PageEnum.INITIAL.index;
    }

    return LoginModel.build(
      authState: state.authState.state,
      pageIndex: pageIndex,
      tagline: taglineContents[pageIndex],
      description: descriptionContents[pageIndex]
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
        pageIndex: vm.pageIndex
      ),
    );
  }
}