import 'package:async_redux/async_redux.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/redux/states/auth.dart';

abstract class BaseAction extends ReduxAction<AppState> {
  // States
  AuthState get authState => state.authState;
}
