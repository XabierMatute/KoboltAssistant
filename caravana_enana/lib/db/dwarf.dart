import 'package:caravana_enana/db/name.dart';
import 'package:caravana_enana/db/title.dart';
import 'dart:math';
import 'package:caravana_enana/db/database.dart';
import 'package:sqflite/sqflite.dart';

class Dwarf {
  final int id;
  final String name;
  final String title;

  Dwarf({required this.id, required this.name, required this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'title': title,
    };
  }

  @override
  String toString() {
    return 'Dwarf{id: $id, name: $name, title: $title}';
  }
}

class DwarfTable {
  static Future<void> insertDwarf(Dwarf dwarf) async {
    final db = await DatabaseService.getDatabase();
    await db.insert(
      'dwarves',
      dwarf.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Inserted dwarf: ${dwarf.id} ${dwarf.name} (${dwarf.title})');
  }

  static Future<List<Dwarf>> getDwarves() async {
    final db = await DatabaseService.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('dwarves');

    return List.generate(maps.length, (i) {
      return Dwarf(
        id: maps[i]['id'],
        name: maps[i]['name'],
        title: maps[i]['title'],
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
      );
    } else {
      return null; // No dwarf found with the given id
    }
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