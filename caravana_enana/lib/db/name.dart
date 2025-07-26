import 'package:caravana_enana/db/database.dart';
import 'package:sqflite/sqflite.dart';

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

  String getTitle() {
    return name;
  }

  String getSubtitle() {
    return description;
  }
}

class NameTable {
  // Initialize the database and create the names table
  static Future<void> initialize() async {
    final db = await DatabaseService.getDatabase();
    await db.execute(
      'CREATE TABLE IF NOT EXISTS names(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
    );
    print('Table names initialized');
  }

  // get first available id
  static Future<int> getFirstAvailableId() async {
    final db = await DatabaseService.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('names', orderBy: 'id DESC', limit: 1);
    if (maps.isNotEmpty) {
      return maps[0]['id'] + 1; // Return the next available id
    } else {
      return 1; // If no names exist, start with id 1
    }
  }

  static Future<void> insertName(Name name) async {
    final db = await DatabaseService.getDatabase();
    await db.insert(
      'names',
      name.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    print('Inserted name: ${name.id} ${name.name}');
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

  // get a specific name by id
  static Future<Name?> getNameById(int id) async {
    final db = await DatabaseService.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'names',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Name(
        id: maps[0]['id'],
        name: maps[0]['name'],
        description: maps[0]['description'],
      );
    } else {
      return null; // No name found with the given id
    }
  }

  // empty the table
  static Future<void> emptyTable() async {
    final db = await DatabaseService.getDatabase();
    await db.delete('names');
    print('Table names emptied');
  }

  // fill the table with example names
  static Future<void> fillTableWithExamples() async {
    final db = await DatabaseService.getDatabase();
    await emptyTable(); // Clear the table first

    for (int i = 0; i < nombresEj.length; i++) {
      final name = Name(
        id: i + 1,
        name: nombresEj[i],
        description: 'Descripción del nombre ${nombresEj[i]}',
      );
      await insertName(name);
    }
    print('Table names filled with example names');
  }

  static Future<void> updateName(int id, String newName, String newDescription) async {
    final db = await DatabaseService.getDatabase();
    await db.update(
      'names',
      {
        'name': newName,
        'description': newDescription,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    print('Updated name: $id to $newName with description $newDescription');
  }


  static Future<void> deleteNameById(int id) async {
    final db = await DatabaseService.getDatabase();
    await db.delete(
      'names',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Deleted name with id: $id');
  }

}

const nombresEj = [
    "Cuarzo", "Amatista", "Topacio", "Esmeralda", "Zafiro",
    "Rubí", "Diamante", "Obsidiana", "Lapislázuli", "Jade",
    "Turquesa", "Granate", "Citrino", "Malaquita", "Ónice",
    "Ágata", "Pirita", "Hematites", "Azurita",
    "Dwayne", "Coral", "Perla", "Nácar", "Aguamarina", "Turmalina",
    "Concha", "Caracola", "Asteroidea", "Anémona",
    "Medusa", "Tortuga", "quelonio", "Polvora",
    "Aarón", "Abdías", "Abdón", "Abel", "Abigaíl", "Abraham", "Absalón", "Ada", 
    "Adán", "Adriel", "Amós", "Ana", "Ananías", "Ariel", "Axa", "Bartolomé", 
    "Belén", "Benjamín", "Bernabé", "Betsabé", "Betuel", "Carmelo", "Carmen", 
    "Dalila", "Daniel", "David", "Débora", "Efraím", "Eleazar", "Elías", 
    "Eliel", "Eliezer", "Elisa", "Eliseo", "Enoc", "Enós", "Esaú", "Esdras", 
    "Ester", "Eva", "Ezequiel", "Fanny", "Gabriel", "Gamaliel", "Gedeón", 
    "Gerson", "Goliat", "Herodes", "Hosanna", "Isaac", "Isaías", "Iska", 
    "Ismael", "Israel", "Iván", "Jacobo", "Jael", "Jaime", "Jair", "Jairo", 
    "Janai", "Jerahmeel", "Jeremías", "Jessica", "Joaquín", "Job", "Joel", 
    "Johann", "José", "Josefa", "Josías", "Josué", "Juan", "Juana", "Judá", 
    "Judit", "Labán", "Lázaro", "Leví", "Lucas", "Magdalena", "Manuel", 
    "María", "Marta", "Micaela", "Miguel", "Milca", "Miqueas", "Míriam", 
    "Nahum", "Nancy", "Natán", "Nathaniel", "Nehemías", "Noé", "Noel", 
    "Noemí", "Rafael", "Rafaela", "Raquel", "Rebeca", "Rut", "Samuel", 
    "Santiago", "Sara", "Saúl", "Sulamita", "Tobías", "Urías", "Uriel", 
    "Zabulón", "Zacarías",
    "Talco", "Granito", "Pizarra", "Mármol", "Cuarcita",
    "Basalto", "Arenisca", "Caliza", "Gneis", "Schist",
    "Dolomita", "Serpentina", "Jaspe",
    "Cianita", "Turmalina", "Cianita", "Espato", "Fluorita",
    "Platino", "Mercurio",
    "Alumina", "Bauxita", "Níquel",
    "Germanio", "Galio", "Indio", "Tantalio", "Niobio",
    "Cobalto", "Litio", "Rubidio", "Estroncio", "Bario",
    "Cromo", "Manganeso", "Molibdeno", "Tungsteno", "Vanadio",
    "Paladio", "Rutenio", "Rhodio", "Osmio", "Iridio",
    "Cerio", "Lantano", "Neodimio", "Praseodimio", "Samario",
    "Europio", "Gadolinio", "Terbio", "Disprosio", "Holmio",
    "Erbio", "Tulio", "Iterbio", "Lutecio", "Escandio",
    "Titanio", "Zirconio", "Hafnio", "Tantalio", "Niobio",
    "Joshua", "Caleb", "Otoniel", "Ehud", "Deborah",
];