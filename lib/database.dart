import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as SQFLite;


class DBProvider {
  DBProvider._();
  static final DBProvider instance = DBProvider._();

  static final _databaseFilename = "geopig.db";
  static final _databaseVersion = 1;

  // Our single instance of the Database
  static Database _db;

  static Future<Database> get db async {
    return DBProvider.instance.database;
  }

  Future<Database> get database async {
    if (_db != null) {
      return _db;
    }

    _db = await buildDatabase();
    return _db;
  }

  static Future deleteDatabase() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseFilename);

    await SQFLite.deleteDatabase(path);
    _db = null;
  }

  static const migrationScripts = [];

  buildDatabase() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseFilename);
    print("Using database $_databaseVersion: $path");

    return await openDatabase(path, version: _databaseVersion,

      // Called only on first launch
      onCreate: (Database db, int version) async {
        var futures = <Future>[];

        futures.add(db.execute("""
          CREATE TABLE user (
            id TEXT PRIMARY KEY,
            name STRING,
            phone NUMBER,
            third_party_id STRING
          );
        """));

        futures.add(db.execute("""
          CREATE TABLE event (
            id TEXT PRIMARY KEY,
            timestamp TEXT,
            type STRING,
            data JSON
          );
        """));

        futures.add(db.execute("""
          CREATE TABLE site (
            id TEXT PRIMARY KEY,
            name TEXT,
            address TEXT,
            geojson TEXT
          );
        """));

        await Future.wait(futures);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        print("Changing database, $oldVersion and $newVersion");
        for (var i = oldVersion - 1; i < newVersion - 1; i++) {
          await db.execute(migrationScripts[i]);
        }
      }
    );

  }

  destroyDatabase() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseFilename);
    var dbFile = new File(path);
    await dbFile.delete();
  }
}
