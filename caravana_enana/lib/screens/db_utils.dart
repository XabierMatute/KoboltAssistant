import 'package:flutter/material.dart';
import 'package:caravana_enana/db/database.dart';
import 'package:caravana_enana/db/name.dart';
import 'package:caravana_enana/db/title.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseUtilsScreen extends StatelessWidget {
  const DatabaseUtilsScreen({super.key});

  Future<void> _clearDatabase(BuildContext context) async {
    try {
      await NameTable.emptyTable();
      await TitleTable.emptyTable();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Base de datos vaciada exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al vaciar la base de datos: $e')),
      );
    }
  }

  Future<void> _fillDatabaseWithExamples(BuildContext context) async {
    try {
      await NameTable.fillTableWithExamples();
      await TitleTable.fillTableWithExamples();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Base de datos llenada con ejemplos')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al llenar la base de datos: $e')),
      );
    }
  }

  Future<void> _showTables(BuildContext context) async {
    try {
      final db = await DatabaseService.getDatabase();
      final List<Map<String, dynamic>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table';"
      );

      if (tables.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Tablas en la Base de Datos'),
            content: const Text('No hay tablas en la base de datos.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
        return;
      }

      List<String> tableDetails = [];
      for (var table in tables) {
        final tableName = table['name'];
        if (tableName != null) {
          final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tableName');
          final rowCount = countResult.isNotEmpty ? countResult[0]['count'] : 0;
          tableDetails.add('$tableName: $rowCount filas');
        }
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Tablas en la Base de Datos'),
          content: Text(tableDetails.isNotEmpty
              ? tableDetails.join('\n')
              : 'No hay información disponible sobre las tablas.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener las tablas: $e')),
      );
    }
  }

  Future<void> _destroyDatabase(BuildContext context) async {
    try {
      final dbPath = await DatabaseService.getDatabasePath();
      await deleteDatabase(dbPath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Base de datos destruida completamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al destruir la base de datos: $e')),
      );
    }
  }

  Future<void> _sanitizeDatabase(BuildContext context) async {
    try {
      await NameTable.normalizeNames();
      await TitleTable.normalizeTitles();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Base de datos saneada exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al sanear la base de datos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilidades de Base de Datos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _clearDatabase(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Vaciar Base de Datos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _fillDatabaseWithExamples(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Llenar Base de Datos con Ejemplos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showTables(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Ver Tablas de la Base de Datos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _sanitizeDatabase(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sanear Base de Datos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _destroyDatabase(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Destruir Base de Datos'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DatabaseUtilsScreen(),
  ));
}