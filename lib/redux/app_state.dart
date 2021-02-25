
import 'package:geopig/redux/states/auth.dart';
import 'package:geopig/redux/states/event.dart';
import 'package:geopig/redux/states/interface.dart';
import 'package:geopig/redux/states/scan.dart';
import 'package:geopig/redux/states/site.dart';
import 'package:geopig/redux/states/user.dart';

class AppState {
  final AuthState authState;
  final UserState userState;
  final InterfaceState interfaceState;
  final EventState eventState;
  final SiteState siteState;
  final ScanState scanState;

  AppState({
    this.authState,
    this.userState,
    this.interfaceState,
    this.eventState,
    this.siteState,
    this.scanState
  });

  AppState copy({
    AuthState authState,
    UserState userState,
    InterfaceState interfaceState,
    EventState eventState,
    SiteState siteState,
    ScanState scanState
  }) {
    return AppState(
      authState: authState ?? this.authState,
      userState: userState ?? this.userState,
      interfaceState: interfaceState ?? this.interfaceState,
      eventState: eventState ?? this.eventState,
      siteState: siteState ?? this.siteState,
      scanState: scanState ?? this.scanState
    );
  }

  static AppState initialState() => AppState(
    authState: AuthState.initialState(),
    userState: UserState.initialState(),
    interfaceState: InterfaceState.initialState(),
    eventState: EventState.initialState(),
    siteState: SiteState.initialState(),
    scanState: ScanState.initialState()
  );

  @override
  bool operator ==(Object other) => (
    identical(this, other) ||
      other is AppState &&
      runtimeType == other.runtimeType &&
      authState == other.authState &&
      userState == other.userState &&
      interfaceState == other.interfaceState &&
      eventState == other.eventState &&
      siteState == other.siteState
      && scanState == other.scanState
  );

  @override
  int get hashCode =>
    authState.hashCode ^
    userState.hashCode ^
    interfaceState.hashCode ^
    eventState.hashCode ^
    siteState.hashCode ^
    scanState.hashCode;
}
