import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Future<Database> initializeDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'enanos_database.db'),
      version: 2, // Incrementa la versión para manejar la migración
      onCreate: (db, version) {
        // Crear tablas iniciales
        db.execute(
          '''
          CREATE TABLE dwarves(
            id INTEGER PRIMARY KEY,
            name INTEGER,
            title INTEGER,
            description TEXT,
            photo_path TEXT
          )
          ''',
        );
        db.execute(
          'CREATE TABLE names(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
        );
        db.execute(
          'CREATE TABLE titles(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Migrar la base de datos para añadir la columna photo_path
          await db.execute(
            'ALTER TABLE dwarves ADD COLUMN photo_path TEXT',
          );
          print('Migración completada: Añadida columna photo_path a la tabla dwarves');
        }
      },
    );
  }

  // Método para destruir la base de datos
  static Future<void> destroyDatabase() async {
    final dbPath = await getDatabasesPath();
    final dbFile = join(dbPath, 'enanos_database.db');
    await deleteDatabase(dbFile);
  }

  // Método para obtener la ruta de la base de datos
  static Future<String> getDatabasePath() async {
    return join(await getDatabasesPath(), 'enanos_database.db');
  }

  // Método para obtener la instancia de la base de datos
  static Future<Database> getDatabase() async {
    return initializeDatabase();
  }
}