


import 'package:geopig/database.dart';
import 'package:geopig/models/connectors/connector.dart';
import 'package:geopig/models/event.dart';

class EventConnector extends DatabaseConnector<Event> {
  String get tableName => 'event';

  List<Event> get events => items;

  @override
  Event parseRecord(Map<String, dynamic> record) {
    return Event.fromMap(record);
  }

  @override
  Future<List<Event>> load() async {
    var db = await DBProvider.db;

    var result = await db.query(tableName);
    List<Event> items = result.map(parseRecord).toList();
    replace(items);
    return items;
  }

  Future upsert(Event record) async {
    await destroyAll();
    await insert(record);

    return replace(await load());
  }

}
