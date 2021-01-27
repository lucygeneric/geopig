import 'package:async_redux/async_redux.dart';
import 'package:geopig/redux/app_state.dart';


var initialState = AppState.initialState();

var store = Store<AppState>(
  initialState: initialState,
);
