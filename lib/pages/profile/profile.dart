import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/models/user.dart';
import 'package:geopig/pages/login/type_animation.dart';
import 'package:geopig/redux/actions/auth.dart';
import 'package:geopig/redux/actions/user.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/services/auth.dart';
import 'package:geopig/redux/store.dart';
import 'package:async_redux/async_redux.dart' as Redux;
import 'package:geopig/type.dart';
import 'package:geopig/utils.dart';
import 'package:geopig/widgets/button.dart';
import 'package:geopig/widgets/input.dart';
class _Profile extends StatefulWidget {

  final User user;
  _Profile({this.user});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<_Profile> {

  final TextEditingController nameController = TextEditingController();

  bool needsToEnterName = false;

  @override
  void initState() {
    nameController.addListener(textUpdateListener);
    if (widget.user.name == null || widget.user.name == '') needsToEnterName = true;
    super.initState();
  }

  @override
  void dispose() {
    nameController.removeListener(textUpdateListener);
    nameController?.dispose();
    super.dispose();
  }

  void textUpdateListener(){
    // redraw when they type
    setState(() {});
  }

  void progress(){

  }


  @override
  Widget build(BuildContext context) {

    List<String> items = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14'];

    return Padding(padding: EdgeInsets.only(top:kGutterWidth,left:kGutterWidth,right: kGutterWidth), child:
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Padding(padding: EdgeInsets.symmetric(vertical: 20.0), child:
              SvgPicture.asset("assets/icon/icon_profile.svg", width: 100)
            ),

            if (widget.user.name == null || widget.user.name == '')
              FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text("I don't even know your name :(", style: TextStyles.subtitle(context)),
                ),

            if (needsToEnterName)
              Column(children: [

                SizedBox(height: 40),
                Input(controller: nameController, hintText: "What can I call you?", maxLines: 1, autofocus: true),
                SizedBox(height: 10),
                Button(label: "Save", onTap: nameController.text == '' ? null : () => store.dispatch(UpdateUserName(name: nameController.text)))
              ]),

            if (!needsToEnterName)
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                Text("${widget.user.name}", style: TextStyles.headline(context)),
                // ListView.builder(
                //   itemCount: items.length,
                //   itemBuilder: (context, index) {
                //     return ListTile(
                //       title: Text('${items[index]}'),
                //     );
                //   },
                // )
              ]),


            Spacer(),

            Container(
              width: double.infinity,
              child: Button(label: 'Logout', onTap: (){
                AuthenticationService.logout();
                store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.IDLE));
                Navigator.of(context).pushNamed("/");
              }, state: ButtonState.PRIMARY,
              )),
        ])
      );
  }
}
class ProfileModel extends Redux.BaseModel<AppState> {
  ProfileModel();

  User user;

  ProfileModel.build({
    @required this.user,
  }) : super(equals: [user]);

  @override
  ProfileModel fromStore() {
    return ProfileModel.build(
      user: state.userState.user
    );
  }
}

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Redux.StoreConnector<AppState, ProfileModel>(
      model: ProfileModel(),
      builder: (BuildContext context, ProfileModel vm) => _Profile(
        user: vm.user
      ),
    );
  }
}