import 'package:geopig/models/user.dart';

class UserState {
  User get user => User.db.user;

  UserState({ User user }) {
    if(user != null) {
      User.db.replace(user);
    }
  }

  UserState copy({User user}) {
    return UserState(user: user ?? this.user);
  }

  static UserState initialState() =>
    UserState(user: User());

  Future persist() async {
    await User.db.upsert(user);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
      other is UserState &&
      runtimeType == other.runtimeType &&
      user == other.user;
  }

  @override
  int get hashCode => user.hashCode;
}
