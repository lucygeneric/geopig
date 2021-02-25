
import 'package:geopig/pages/dashboard/dashboard.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/redux/base_action.dart';
import 'package:geopig/redux/states/scan.dart';

class UpdateScanFlowState extends BaseAction {
  final ScanFlowState value;

  UpdateScanFlowState({ this.value }) : assert(value != null);

  @override
  Future<AppState> reduce() async {
    if (value == null) return null;

    ScanState scanState = ScanState(state: value);

    return state.copy(scanState: scanState);
  }
}