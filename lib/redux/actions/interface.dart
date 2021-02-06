
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/redux/base_action.dart';

class UpdateBusy extends BaseAction {
  final bool value;

  UpdateBusy({ this.value }) : assert(value != null);

  @override
  Future<AppState> reduce() async {
    if (value == null) return null;

    return state.copy(
      interfaceState: interfaceState.copy(busy: value)
    );
  }
}

class UpdatePage extends BaseAction {
  final int index;

  UpdatePage({ this.index }) : assert(index != null);

  @override
  Future<AppState> reduce() async {
    if (index == null) return null;

    return state.copy(
      interfaceState: interfaceState.copy(pageIndex: index)
    );
  }
}