import 'package:caravana_enana/db/name.dart';
import 'package:caravana_enana/db/title.dart';
import 'dart:math';
import 'package:caravana_enana/db/database.dart';
import 'package:sqflite/sqflite.dart';

class Dwarf {
  final int id;
  final String name;
  final String title;
  final String? photoPath; // Optional path to the image

  Dwarf({required this.id, required this.name, required this.title, this.photoPath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'photo_path': photoPath, // Include photoPath in the map
    };
  }

  @override
  String toString() {
    return 'Dwarf{id: $id, name: $name, title: $title, photoPath: $photoPath}';
  }

  // Implementación de copyWith
  Dwarf copyWith({
    int? id,
    String? name,
    String? title,
    String? photoPath,
  }) {
    return Dwarf(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}

class DwarfTable {
  // Initialize the database and create the dwarves table
  static Future<void> initialize() async {
    final db = await DatabaseService.getDatabase();
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS dwarves(
        id INTEGER PRIMARY KEY,
        name TEXT,
        title TEXT,
        photo_path TEXT
      )
      ''',
    );
    print('Table dwarves initialized');
  }

  static Future<void> insertDwarf(Dwarf dwarf) async {
    final db = await DatabaseService.getDatabase();
    await db.insert(
      'dwarves',
      dwarf.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Inserted dwarf: ${dwarf.id} ${dwarf.name} (${dwarf.title}) Photo: ${dwarf.photoPath}');
  }

  static Future<List<Dwarf>> getDwarves() async {
    final db = await DatabaseService.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('dwarves');

    return List.generate(maps.length, (i) {
      return Dwarf(
        id: maps[i]['id'],
        name: maps[i]['name'],
        title: maps[i]['title'],
        photoPath: maps[i]['photo_path'], // Retrieve photoPath
      );
    });
  }

  static Future<Dwarf?> getDwarfById(int id) async {
    final db = await DatabaseService.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'dwarves',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Dwarf(
        id: maps[0]['id'],
        name: maps[0]['name'],
        title: maps[0]['title'],
        photoPath: maps[0]['photo_path'], // Retrieve photoPath
      );
    } else {
      return null; // No dwarf found with the given id
    }
  }

  static Future<void> updateDwarfPhoto(int id, String photoPath) async {
    final db = await DatabaseService.getDatabase();
    await db.update(
      'dwarves',
      {'photo_path': photoPath},
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Updated photo for dwarf with id: $id');
  }

  static Future<void> emptyTable() async {
    final db = await DatabaseService.getDatabase();
    await db.delete('dwarves');
    print('Table dwarves emptied');
  }

  static Future<Dwarf> generateRandomDwarf() async {
    final random = Random();

    // Get random name and title
    final names = await NameTable.getNames();
    final titles = await TitleTable.getTitles();

    if (names.isEmpty || titles.isEmpty) {
      throw Exception('No names or titles available to generate a dwarf');
    }

    final randomName = names[random.nextInt(names.length)].name;
    final randomTitle = titles[random.nextInt(titles.length)].name;

    return Dwarf(
      id: DateTime.now().millisecondsSinceEpoch, // Generate unique ID
      name: randomName,
      title: randomTitle,
      photoPath: null, // Default photoPath is null
    );
  }

  static Future<void> deleteDwarfById(int id) async {
    final db = await DatabaseService.getDatabase();
    await db.delete(
      'dwarves',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Deleted dwarf with id: $id');
  }
}