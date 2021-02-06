


import 'package:geopig/database.dart';
import 'package:geopig/models/connectors/connector.dart';
import 'package:geopig/models/site.dart';

class SiteConnector extends DatabaseConnector<Site> {
  String get tableName => 'site';

  List<Site> get sites => items;

  @override
  Site parseRecord(Map<String, dynamic> record) {
    return Site.fromMap(record);
  }

  @override
  Future<List<Site>> load() async {
    var db = await DBProvider.db;

    var result = await db.query(tableName);
    List<Site> items = result.map(parseRecord).toList();
    replace(items);
    return items;
  }

  Future upsert(Site record) async {
    await destroyAll();
    await insert(record);

    return replace(await load());
  }

}
