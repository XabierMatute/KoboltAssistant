import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:caravana_enana/db/name.dart';
import 'package:caravana_enana/db/title.dart';
import 'package:caravana_enana/db/dwarf.dart';


const tables = {
  'dwarves': DwarfTable,
  'names': NameTable,
  'titles': TitleTable,
};

class DatabaseService {
  static Future<Database> initializeDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'enanos_database.db'),
      onCreate: createTables,
      version: 1,
    );
  }

  static FutureOr<void> createTables(db, version) {
      for (var table in tables.values) {
        table.initialize();
      }
      print('All tables initialized');
      return Future.wait(tables.values.map((table) => table.initialize()));
  }

  static Future<String> getDatabasePath() async {
    return join(await getDatabasesPath(), 'enanos_database.db');
  }

  static Future<void> destroyDatabase() async {
    final dbFile = await getDatabasePath();
    await deleteDatabase(dbFile);
  }

  static Future<Database> getDatabase() async {
    return initializeDatabase();
  }
}
