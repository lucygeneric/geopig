
import 'package:geopig/services/auth.dart';

class AuthState {

  AuthenticatorState state;

  AuthState({ AuthenticatorState state }) {
    this.state = state;
  }

  AuthState copy({ AuthenticatorState state }) {
    return AuthState(state: state ?? this.state);
  }

  static AuthState initialState() => AuthState(state: AuthenticatorState.IDLE);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
      other is AuthState &&
      runtimeType == other.runtimeType &&
      state == other.state;
  }

  @override
  int get hashCode => state.hashCode;
}
