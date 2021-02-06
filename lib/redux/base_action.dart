import 'package:async_redux/async_redux.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/redux/states/auth.dart';
import 'package:geopig/redux/states/event.dart';
import 'package:geopig/redux/states/interface.dart';
import 'package:geopig/redux/states/site.dart';
import 'package:geopig/redux/states/user.dart';

abstract class BaseAction extends ReduxAction<AppState> {
  // States
  AuthState get authState => state.authState;
  UserState get userState => state.userState;
  InterfaceState get interfaceState => state.interfaceState;
  EventState get eventState => state.eventState;
  SiteState get siteState => state.siteState;
}
