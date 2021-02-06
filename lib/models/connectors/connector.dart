
import 'package:geopig/database.dart';
import 'package:geopig/models/base.dart';
import 'package:geopig/utils.dart';

abstract class DatabaseConnector<T extends BaseModel> {
  // This has to be a getter rather than a field because Dart doesn't seem to allow overriding fields.
  String get tableName => throw "Not implemented";

  List<T> items = [];

  T parseRecord(Map<String, dynamic> record);

  Future<dynamic> load() async {
    var db = await DBProvider.db;
    var result = await db.query(tableName);
    List<T> items = result.map(parseRecord).toList();
    replace(items);
    return items;
  }

  Future destroy(String id) async {
    assert(id != null, "Can't destroy a null ID");
    var db = await DBProvider.db;
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  Future<T> loadRecord(String id) async {
    var db = await DBProvider.db;
    var result = await db.query(tableName, where: "id = ?", whereArgs: [id]);
    if (result.isEmpty) return null;
    return parseRecord(result.first);
  }

  Future<bool> recordExists(String id) async {
    if (id == null) {
      return false;
    }
    var db = await DBProvider.db;
    var result = await db.query(tableName, columns: ['id'], where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  Future upsert(T record) async {
    var exists = await recordExists(record.id);
    if (exists) {
      await update(record);
    }
    else {
      await insert(record);
    }
  }

  Future upsertMany(List<T> records) async {
    for (T record in records){
      var exists = await recordExists(record.id);
      (exists) ? await update(record) : await insert(record);
    }
    return replace(await load());
  }

  insert(T record) async {
    try {
      var db = await DBProvider.db;
      await db.insert(tableName, record.toMap());
    } catch (exception){
      Utils.logError("Insert Failed\n$exception");
    }
  }

  update(T record) async {
    try {
      var db = await DBProvider.db;
      await db.update(tableName, record.toMap(), where: 'id = ?', whereArgs: [record.id]);
    } catch (exception){
      Utils.logError("Update Failed\n$exception");
    }
  }

  Future destroyAll() async {
    var db = await DBProvider.db;
    await db.delete(tableName);
    clear();
  }

  clear() {
    items = [];
  }

  replace(dynamic items) {
    this.items = items;
  }

  add(T item) {
    items.add(item);
  }

  T get(String id) {
    return items.firstWhere((item) => item.id == id, orElse: () => null);
  }

  T operator [](String id) {
    return get(id);
  }

  int get length {
    return items.length;
  }
}
