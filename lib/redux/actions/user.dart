
import 'package:geopig/models/user.dart';
import 'package:geopig/redux/app_state.dart';
import 'package:geopig/redux/base_action.dart';


class CreateUserFromNumber extends BaseAction {

  final String number;

  CreateUserFromNumber({ this.number }) : assert(number != null);

  @override
  Future<AppState> reduce() async {
    if (number == null) return null;

    User user = User(phone: number);
    User.db.upsert(user);

    return state.copy(
      userState: userState.copy(user: user)
    );
  }
}

class UpdateUserName extends BaseAction {

  final String name;

  UpdateUserName({ this.name }) : assert(name != null);

  @override
  Future<AppState> reduce() async {
    if (name == null) return null;

    User user = User(name: name);
    User.db.upsert(user);

    return state.copy(
      userState: userState.copy(user: user)
    );
  }
}