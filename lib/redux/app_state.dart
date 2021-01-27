
import 'package:geopig/redux/states/auth.dart';

class AppState {
  final AuthState authState;

  AppState({
    this.authState
  });

  AppState copy({
    AuthState authState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
    );
  }

  static AppState initialState() => AppState(
    authState: AuthState.initialState(),
  );

  @override
  bool operator ==(Object other) => (
    identical(this, other) ||
      other is AppState &&
      runtimeType == other.runtimeType &&
      authState == other.authState
  );

  @override
  int get hashCode =>
    authState.hashCode;
}
