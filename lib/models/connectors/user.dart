


import 'package:geopig/database.dart';
import 'package:geopig/models/connectors/connector.dart';
import 'package:geopig/models/user.dart';

class UserConnector extends DatabaseConnector<User> {
  String get tableName => 'user';

  User get user => items.isNotEmpty ? items.first : null;

  @override
  User parseRecord(Map<String, dynamic> record) {
    return User.fromMap(record);
  }

  @override
  Future<User> load() async {
    var db = await DBProvider.db;

    var result = await db.query(tableName);
    User item = parseRecord(result.first);
    replace(item);
    return item;
  }

  @override
  replace(dynamic user) {
    this.items = [user];
  }

}
