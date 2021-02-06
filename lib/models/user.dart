

import 'package:geopig/models/connectors/user.dart';
import 'package:geopig/redux/states/user.dart';
import 'package:geopig/redux/store.dart' as Store;
import 'package:geopig/models/base.dart';
import 'package:uuid/uuid.dart';

var uuid = new Uuid();

class User implements BaseModel {

  String id;
  String name;
  String phone;
  String thirdPartyId;

  static UserConnector db = UserConnector();

  User({ this.id, this.name, this.phone, this.thirdPartyId });

  static UserState get store => Store.store.state.userState;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name']
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    "id": id,
    "third_party_id": thirdPartyId,
    "name": name,
    "phone": phone,
  };

}
