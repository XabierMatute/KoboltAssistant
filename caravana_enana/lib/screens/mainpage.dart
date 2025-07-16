import 'package:flutter/material.dart';
import 'package:caravana_enana/screens/attributes.dart';
import 'package:caravana_enana/screens/dwarves.dart';
import 'package:caravana_enana/screens/generate_dwarves.dart';
import 'package:caravana_enana/screens/db_utils.dart'; // Importa la página de utilidades de base de datos

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enanavana'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: PageList(),
    );
  }
}

class PageList extends StatelessWidget {
  const PageList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.list),
          title: const Text('Atributos'),
          subtitle: const Text('Gestiona nombres, títulos y otros atributos'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AttributesScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Base de Datos de Enanos'),
          subtitle: const Text('Explora y gestiona la base de datos de enanos'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DwarvesScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.build),
          title: const Text('Generar Enanos'),
          subtitle: const Text('Crea nuevos enanos con atributos personalizados'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GenerateDwarvesScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Utilidades de Base de Datos'),
          subtitle: const Text('Vacía o llena la base de datos con ejemplos'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DatabaseUtilsScreen()),
            );
          },
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MainPage(),
  ));
}