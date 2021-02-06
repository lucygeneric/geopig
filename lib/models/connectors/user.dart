


import 'package:geopig/database.dart';
import 'package:geopig/models/connectors/connector.dart';
import 'package:geopig/models/user.dart';

class UserConnector extends DatabaseConnector<User> {
  String get tableName => 'user';

  User get  user => items.isNotEmpty ? items.last : null;

  @override
  User parseRecord(Map<String, dynamic> record) {
    return User.fromMap(record);
  }

  @override
  Future<User> load() async {
    var db = await DBProvider.db;

    var result = await db.query(tableName);
    User item = User();
    if (result.length == 1) {
      item = parseRecord(result.last);
    }
    replace(item);
    return item;
  }

  Future upsert(User record) async {
    await destroyAll();
    await insert(record);

    return replace(await load());
  }

  @override
  replace(dynamic user) {
    this.items = [user];
  }

}
