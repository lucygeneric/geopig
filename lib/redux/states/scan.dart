import 'package:geopig/pages/dashboard/dashboard.dart';

enum ScanFlowState { IDLE, SCANNED_IN, SCANNING_OUT, SCANNED_OUT, FORCE_SCAN_OUT }

class ScanState {

  ScanFlowState state;

  ScanState({ ScanFlowState state }) {
    this.state = state;
  }

  ScanState copy({ ScanFlowState state }) {
    return ScanState(state: state ?? this.state);
  }

  static ScanState initialState() => ScanState(state: ScanFlowState.IDLE);

  void forceState(ScanFlowState newState) => this.state = newState;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
      other is ScanState &&
      runtimeType == other.runtimeType &&
      state == other.state;
  }

  @override
  int get hashCode => state.hashCode;
}
