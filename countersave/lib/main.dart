import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Counter {
  final int id;
  final int value;

  const Counter({required this.id, required this.value});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
    };
  }
  @override
  String toString() {
    return 'Counter{id: $id, value: $value}';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('WidgetsFlutterBinding initialized');
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'counter_database.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE counters(id INTEGER PRIMARY KEY, value INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  print('Database opened');

  Future<void> insertCounter(Counter counter) async {
      // Get a reference to the database.
      final db = await database;

      // Insert the Counter into the database.
      await db.insert(
        'counters',
        counter.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Counter inserted: $counter');
    }

  var zeroCounter = Counter(id: 0, value: 0);
  // Insert a counter into the database.
  await insertCounter(zeroCounter);
  print('Counter with id 0 inserted');

  Future<List<Counter>> counters() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the counters.
    final List<Map<String, dynamic>> maps = await db.query('counters');

    // Convert the List<Map<String, dynamic> into a List<Counter>.
    return List.generate(maps.length, (i) {
      return Counter(
        id: maps[i]['id'],
        value: maps[i]['value'],
      );
    });
  }
  // Print all counters in the database.
  List<Counter> allCounters = await counters();
  print('All counters in the database: $allCounters');

  Future<void> updateCounter(Counter counter) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Counter.
    await db.update(
      'counters',
      counter.toMap(),
      // Ensure that the Counter has a matching id.
      where: 'id = ?',
      whereArgs: [counter.id],
    );
    print('Counter updated: $counter');
  }

  // Update the counter with id 0 to have a value of 42.
  zeroCounter = Counter(id: 0, value: 42);
  await updateCounter(zeroCounter);
  print('Counter with id 0 updated to value 42');
  allCounters = await counters();
  print('All counters in the database after update: $allCounters');

  Future<void> deleteCounter(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Counter from the database.
    await db.delete(
      'counters',
      // Use a `where` clause to delete a specific Counter.
      where: 'id = ?',
      // Pass the Counter's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
    print('Counter with id $id deleted');
  }
  // Delete the counter with id 0.
  await deleteCounter(0);
  print('Counter with id 0 deleted');
  allCounters = await counters();
  print('All counters in the database after deletion: $allCounters');

  // Populate the database with some initial data (5 counters with value 0).

  for (int i = 1; i <= 5; i++) {
    // Obtén la instancia de la base de datos
    final db = await database;
  
    // Verifica si el counter con el ID ya existe en la base de datos
    final existingCounters = await db.query(
      'counters',
      where: 'id = ?',
      whereArgs: [i],
    );
  
    // Si no existe, lo inserta
    if (existingCounters.isEmpty) {
      await insertCounter(Counter(id: i, value: 0));
      print('Counter with id $i inserted');
    } else {
      print('Counter with id $i already exists');
    }
  }
  print('5 counters with value 0 inserted');
  allCounters = await counters();
  print('All counters in the database after initial data: $allCounters');


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(":3"),
        // save and load the counter value from the database
        actions: [
          FutureBuilder<List<Counter>>(
            future: DatabaseHelper.counters(), // Obtiene los counters desde la base de datos
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
              }
              final countersList = snapshot.data!;
              return DropdownButton<int>(
                hint: const Text('Load Counter'),
                items: countersList.map((counter) {
                  return DropdownMenuItem<int>(
                    value: counter.id,
                    child: Text('ID: ${counter.id}, Value: ${counter.value}'),
                  );
                }).toList(),
                onChanged: (selectedId) async {
                  if (selectedId != null) {
                    final selectedCounter = countersList.firstWhere((c) => c.id == selectedId);
                    setState(() {
                      _counter = selectedCounter.value; // Carga el valor del counter seleccionado
                    });
                  }
                },
              );
            },
          ),
          FutureBuilder<List<Counter>>(
            future: DatabaseHelper.counters(), // Obtiene los counters desde la base de datos
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
              }
              final countersList = snapshot.data!;
              return DropdownButton<int>(
                hint: const Text('Save Counter'),
                items: countersList.map((counter) {
                  return DropdownMenuItem<int>(
                    value: counter.id,
                    child: Text('ID: ${counter.id}, Value: ${counter.value}'),
                  );
                }).toList(),
                onChanged: (selectedId) async {
                  if (selectedId != null) {
                    final updatedCounter = Counter(id: selectedId, value: _counter);
                    await DatabaseHelper.updateCounter(updatedCounter); // Guarda el valor actual del contador en la base de datos
                    setState(() {}); // Refresca la UI
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class Counter {
//   final int id;
//   final int value;

//   const Counter({required this.id, required this.value});

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'value': value,
//     };
//   }

//   @override
//   String toString() {
//     return 'Counter{id: $id, value: $value}';
//   }
// }

class DatabaseHelper {
  static Future<Database> _initializeDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'counter_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE counters(id INTEGER PRIMARY KEY, value INTEGER)',
        );
      },
      version: 1,
    );
  }

  static Future<Database> getDatabase() async {
    return _initializeDatabase();
  }

  static Future<List<Counter>> counters() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('counters');
    return List.generate(maps.length, (i) {
      return Counter(
        id: maps[i]['id'],
        value: maps[i]['value'],
      );
    });
  }

  static Future<void> insertCounter(Counter counter) async {
    final db = await getDatabase();
    await db.insert(
      'counters',
      counter.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateCounter(Counter counter) async {
    final db = await getDatabase();
    await db.update(
      'counters',
      counter.toMap(),
      where: 'id = ?',
      whereArgs: [counter.id],
    );
  }

  static Future<void> deleteCounter(int id) async {
    final db = await getDatabase();
    await db.delete(
      'counters',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}