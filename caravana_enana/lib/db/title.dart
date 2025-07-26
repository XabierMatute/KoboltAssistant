import 'package:caravana_enana/db/database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FantasyTitle {
  final int id;
  final String name;
  final String description;

  FantasyTitle({required this.id, required this.name, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Title{id: $id, name: $name, description: $description}';
  }
}

class TitleTable {
  // Initialize the database and create the titles table
  static Future<void> initialize() async {
    final db = await DatabaseService.getDatabase();
    await db.execute(
      'CREATE TABLE IF NOT EXISTS titles(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
    );
    print('Table titles initialized');
  }


  static Future<void> insertTitle(FantasyTitle title) async {
    final db = await DatabaseService.getDatabase();
    await db.insert(
      'titles',
      title.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Inserted title: ${title.id} ${title.name}');
  }

  static Future<List<FantasyTitle>> getTitles() async {
    final db = await DatabaseService.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('titles');

    return List.generate(maps.length, (i) {
      return FantasyTitle(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
      );
    });
  }

  static Future<FantasyTitle?> getTitleById(int id) async {
    final db = await DatabaseService.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'titles',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return FantasyTitle(
        id: maps[0]['id'],
        name: maps[0]['name'],
        description: maps[0]['description'],
      );
    } else {
      return null; // No title found with the given id
    }
  }

  static Future<void> emptyTable() async {
    final db = await DatabaseService.getDatabase();
    await db.delete('titles');
    print('Table titles emptied');
  }

  static Future<void> fillTableWithExamples() async {
    final db = await DatabaseService.getDatabase();
    await emptyTable(); // Clear the table first

    for (int i = 0; i < titlesEj.length; i++) {
      final title = FantasyTitle(
        id: i + 1,
        name: titlesEj[i],
        description: 'Descripción del título ${titlesEj[i]}',
      );
      await insertTitle(title);
    }
    print('Table titles filled with example titles');
  }

  static Future<void> updateTitle(int id, String newName, String newDescription) async {
    final db = await DatabaseService.getDatabase();
    await db.update(
      'titles',
      {
        'name': newName,
        'description': newDescription,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    print('Updated title: $id to $newName with description $newDescription');
  }

  static Future<void> deleteTitleById(int id) async {
    final db = await DatabaseService.getDatabase();
    await db.delete(
      'titles',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Deleted title with id: $id');
  }
}

const titlesEj = [
    "El barbudo", "El minero",
    "El sabio", "El aventurero", "El explorador",
    "El bruto", "El ingenioso", "El astuto",
    "El coleccionista",
    "El maduro", "el infantil",
    "El fuerte", "El ágil", "El resistente",
    "El sigiloso", "El valiente", "El leal",
    "El hábil", "El astuto", "El letrado",
    "El conocedor", "El experto", "El erudito",
    "El recio", "El noble", "El honorable",
    "El generoso", "El fiel",
    "El tenaz", "El perseverante", "El decidido",
    "El audaz", "El intrépido", "El valeroso",
    "El incansable", "El tacaño", "El avaro",
    "El codicioso", "El desconfiado", "El elficado",
    "El desconfiado",
    "pocabarba", "barbablanca", "barbafuerte", "barbaleal",
    "patascortas", "pataslargas", "patasfuertes",
    "ojosbrillantes", "ojososcuros", "ojosclaros",
    "el narices", "el chato",
    "el honrado",
    "el leal", "el fiel", "el generoso",
    "el uraño", "el testarudo", "el decidido",
    "el salido", "el borracho", "el beodo",
    "de la piedra", "de las minas",
    "picoroto", "dospicos",
    "dinamitas",
    "el del hacha",
    "la roca",
    "el bizco", "el tuerto", "el ciego", "ojoselficos",
    "el topo", "el murcielago", "el gritos",
    "el palido", "bigoteretorcido",
    "bigotefino", "bigotegordo",
    "el basado", "el goblin",
    "el minimalista", "el enano",
    "el nordico", "el verde", "el rojo",
    "sudores",
    "el sabio",
    "el mudo", "el sordo", "el ciego",
    "el loco", "el chiflado", "el tullido",
    "el cojo", "el manco", "el tuerto",
    "el barbudo", "el peludo", "el calvo",
    "el septimo",
    "el gruñón", "el dormilón", "el feliz",
    "el alegre", "el bromista", "el cachondo",
    "palalarga", "palacorta", "palafuerte", "palancha",
    "el cantarín", "el trovador", "el poeta",
    "el músico", "el bailarín", "el artista",
    "el escultor", "el artesano", "el herrero",
    "el bardo", "el juglar", "el cuentacuentos",
    "el aventurero", "el explorador", "el buscador",
    "el cazador", "el rastreador", "el trampero",
    "el batallitas",
    "el mocoso", "el joven", "el viejo",
    "el anciano", "el maduro", "el niño",
    "el adulto", "el veterano", "el experimentado",
    "el timido", "el cobarde", "el miedoso",
    "el valiente", "el audaz", "el intrépido",
    "el decidido", "el resuelto", "el firme",
    "testadura", "caracortada", "caracorta", "carafuerte",
    "cabezaabollada", "cabezacorta", "cabezafuerte",
    "cabezapiedra", "el penoso", "el pesado",
    "estornudos", "catarros", "toses", "carraspeos",
    "ojoloco", "sombreros", "gorrolargo", "gorros",
    "el putero", "el chulo", "el sombrerero",
    "el loco", "el biceps", "el musculoso",
    "peñas", "el quemado",
    "el digno",
    "el orco",
    "tragaldabas",
    "el dorado", "el plateado", "el bronceado",
    "el vanal",
    "el vanidoso", "el orgulloso", "el glamuroso",
    "el elegante", "el sofisticado",
    "el avaro", "el codicioso", "el ambicioso",
    "el tacaño", "el mezquino", "el rácano",
    "el perezoso", "el holgazán", "el vago",
    "el dormilón", "el soñador", "el distraído",
    "el curioso", "el observador", "el investigador",
    "el analista", "el científico", "el lógico",
    "el racional", "el pensador", "el filósofo",
    "el estratega", "el planificador", "el organizador",
    "el líder", "el capitán", "el comandante",
    "el lujurioso", "el seductor", "el catador",
    "el amante", "el romántico", "el apasionado",
    "el gulas", "el tragón", "el comilón",
    "el gourmet", "el sibarita", "el gastrónomo",
    "el chef", "el cocinero", "el repostero",
    "el humano",
    "el escamoso",
    "alientodragón",
    "barbasangrientas",
    "barbablanca", "barbaverde", "barbaroja",
    "barbablanca", "barbafuego", "barbafresno",
    "barbafuego", "barbaverde", "barbapiedra",
    "barbafuerte", "barbapiedra", "barbaverde",
    "barbacromada",
    ];