import 'package:geopig/models/connectors/site.dart';
import 'package:geopig/redux/states/site.dart';
import 'package:geopig/redux/store.dart' as Store;
import 'package:geopig/models/base.dart';
import 'package:uuid/uuid.dart';

var uuid = new Uuid();

class Site implements BaseModel {

  String id;
  String name;
  String address;
  String geojson;

  static SiteConnector db = SiteConnector();

  Site({ this.id, this.name, this.address, this.geojson });

  static SiteState get store => Store.store.state.siteState;

  factory Site.fromMap(Map<String, dynamic> map) {
    return Site(
      id: map['id'] ?? uuid.v4(),
      name: map['name'],
      address: map['address'],
      geojson: map['geojson'],
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "address": address,
    "geojson": geojson
  };

}
