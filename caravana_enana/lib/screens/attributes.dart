import 'package:flutter/material.dart';
import 'package:caravana_enana/screens/names.dart';
import 'package:caravana_enana/screens/titles.dart';

class AttributesScreen extends StatelessWidget {
  const AttributesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atributos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          ListTile( 
            leading: const Icon(Icons.person),
            title: const Text('Nombres'),
            subtitle: const Text('Explora y gestiona los nombres disponibles'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NamesScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.title),
            title: const Text('Títulos'),
            subtitle: const Text('Explora y gestiona los títulos disponibles'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TitlesScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AttributesScreen(),
  ));
}