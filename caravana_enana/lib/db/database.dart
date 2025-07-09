import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Future<Database> initializeDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'enanos_database.db'),
      onCreate: (db, version) {
        // Aquí puedes crear múltiples tablas si es necesario
        db.execute(
          'CREATE TABLE enanos(id INTEGER PRIMARY KEY, name TEXT, title TEXT)',
          // , job TEXT, age TEXT, description TEXT)',
        );
        db.execute(
          'CREATE TABLE names(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
        );
        // db.execute(
        //   'CREATE TABLE jobs(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
        // );
        // db.execute(
        //   'CREATE TABLE clans(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
        // );
        db.execute(
          'CREATE TABLE titles(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<Database> getDatabase() async {
    return initializeDatabase();
  }
}