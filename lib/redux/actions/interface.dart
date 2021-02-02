
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/redux/base_action.dart';
import 'package:geopig/redux/states/interface.dart';

class UpdateBusy extends BaseAction {
  final bool value;

  UpdateBusy({ this.value }) : assert(value != null);

  @override
  Future<AppState> reduce() async {
    if (value == null) return null;

    InterfaceState interfaceState = InterfaceState(busy: value);
    print("Interface State reducer is setting busy to $value");
    return state.copy(
      interfaceState: interfaceState.copy(busy: value)
    );
  }
}