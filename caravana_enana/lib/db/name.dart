import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:enanos/db/database.dart';

class Name {
  final int id;
  final String name;
  final String description;

  Name({required this.id, required this.name, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Name{id: $id, name: $name, description: $description}';
  }
}

class NameTable {
  static Future<void> insertName(Name name) async {
    final db = await DatabaseService.getDatabase();
    await db.insert(
      'names',
      name.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Name>> getNames() async {
    final db = await DatabaseService.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('names');

    return List.generate(maps.length, (i) {
      return Name(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
      );
    });
  }
}