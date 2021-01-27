
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/redux/base_action.dart';
import 'package:geopig/redux/states/auth.dart';
import 'package:geopig/services/auth.dart';

class UpdateAuthenticatorState extends BaseAction {
  final AuthenticatorState value;

  UpdateAuthenticatorState({ this.value }) : assert(value != null);

  @override
  Future<AppState> reduce() async {
    if (value == null) return null;

    AuthState authState = AuthState(state: value);

    return state.copy(authState: authState);
  }
}