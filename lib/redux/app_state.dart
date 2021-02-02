
import 'package:geopig/redux/states/auth.dart';
import 'package:geopig/redux/states/interface.dart';

class AppState {
  final AuthState authState;
  final InterfaceState interfaceState;

  AppState({
    this.authState,
    this.interfaceState
  });

  AppState copy({
    AuthState authState,
    InterfaceState interfaceState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
      interfaceState: interfaceState ?? this.interfaceState
    );
  }

  static AppState initialState() => AppState(
    authState: AuthState.initialState(),
    interfaceState: InterfaceState.initialState()
  );

  @override
  bool operator ==(Object other) => (
    identical(this, other) ||
      other is AppState &&
      runtimeType == other.runtimeType &&
      authState == other.authState &&
      interfaceState == other.interfaceState
  );

  @override
  int get hashCode =>
    authState.hashCode ^
    interfaceState.hashCode;
}
