import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geopig/color.dart';
import 'package:geopig/consts.dart';
import 'package:geopig/mixins/dialog.dart';
import 'package:geopig/models/event.dart';
import 'package:geopig/models/site.dart';
import 'package:geopig/models/user.dart';
import 'package:geopig/pages/profile/activity.dart';
import 'package:geopig/pages/profile/site.dart';
import 'package:geopig/redux/actions/auth.dart';
import 'package:geopig/redux/actions/user.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/services/auth.dart';
import 'package:geopig/redux/store.dart';
import 'package:async_redux/async_redux.dart' as Redux;
import 'package:geopig/type.dart';
import 'package:geopig/widgets/button.dart';
import 'package:geopig/widgets/input.dart';
class _Profile extends StatefulWidget {

  final User user;
  final List<Event> events;
  final List<Site> sites;
  _Profile({this.user, this.events, this.sites});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<_Profile> with DialogBuilder {

  final TextEditingController nameController = TextEditingController();

  bool get needsToEnterName => (widget.user?.name == null || widget.user?.name == '');

  @override
  void initState() {
    nameController.addListener(textUpdateListener);
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

  List<Widget> get events {
    List<Widget> events = [];
    events.add(
      Container(
        padding: EdgeInsets.symmetric(vertical: 20), child: Text("Recent Activity", style: TextStyles.important(context))
      ),
    );
    for(Event event in widget.events.take(6))
      events.add(ActivityTile(event: event, hilite: widget.events.indexOf(event) < 2));
    if (widget.events.length > 6)
      events.add(Button(label: "Show more events", state: ButtonState.INTERFACE,
        onTap: () => Fluttertoast.showToast(msg: 'Yeah getting there... soon. Soon.',toastLength: Toast.LENGTH_LONG, backgroundColor: PigColor.primary, textColor: Colors.white)
      ));
    return events;
  }

  List<Widget> get sites {
    List<Widget> sites = [];
    sites.add(
      Container(
        padding: EdgeInsets.symmetric(vertical: 20), child: Text("My Sites", style: TextStyles.important(context))
      ),
    );
    for(Site site in widget.sites){
      sites.add(SiteTile(site: site));
    }
    return sites;
  }


  @override
  Widget build(BuildContext context) {

    Size s = MediaQuery.of(context).size;

    return Container(
      width: s.width, height: s.height,
      padding: EdgeInsets.only(top:kGutterWidth,left:kGutterWidth,right: kGutterWidth),
      child: Stack(children: [
        Positioned(
          top: 0, left: 0, right: 0, bottom: 75,
          child: SingleChildScrollView(child:
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Padding(padding: EdgeInsets.symmetric(vertical: 20.0), child:
                  SvgPicture.asset("assets/icon/icon_profile.svg", width: 100)
                ),

                if (needsToEnterName)
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
                  Text("${widget.user.name}", style: TextStyles.headline(context), textAlign: TextAlign.center),

                if (!needsToEnterName)
                  ...events,

                if (!needsToEnterName)
                  ...sites
              ]),
            )
          ),

          // fade widget
          Positioned(bottom: 60, left: 0, right: 0, child:
            Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.0), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          Positioned(bottom: 0, left: 0, right: 0, child:
            Button(label: 'Logout', onTap: (){
              generalDialog(context: context,
                title: "Sure you want to log out?",
                copy: "You will have to log in again.\nHow annoying.",
                buttons: [
                  Button(label: "Yes. I enjoy extra work.", onTap: (){
                    AuthenticationService.logout();
                    store.dispatch(LogoutUser());
                    store.dispatch(UpdateAuthenticatorState(value: AuthenticatorState.IDLE));
                    Navigator.of(context).pushNamed("/");
                  }, state: ButtonState.PRIMARY),
                  Button(label: "No! Take me back to safety.", onTap:() => Navigator.pop(context))
                ]);
              }, state: ButtonState.PRIMARY,
            )
          ),
        ])
      );
  }
}
class ProfileModel extends Redux.BaseModel<AppState> {
  ProfileModel();

  User user;
  List<Event> events;
  List<Site> sites;

  ProfileModel.build({
    @required this.user,
    @required this.events,
    @required this.sites,
  }) : super(equals: [user, events, sites]);

  @override
  ProfileModel fromStore() {

    List<Event> events = List.of(state.eventState.events);
    events.sort((dynamic a, dynamic b){
      return b.timestamp.compareTo(a.timestamp);
    });

    return ProfileModel.build(
      user: state.userState.user,
      events: events,
      sites: state.siteState.sites
    );
  }
}

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Redux.StoreConnector<AppState, ProfileModel>(
      model: ProfileModel(),
      builder: (BuildContext context, ProfileModel vm) => _Profile(
        user: vm.user,
        events: vm.events,
        sites: vm.sites
      ),
    );
  }
}