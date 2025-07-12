import 'package:flutter/material.dart';
import 'package:caravana_enana/db/name.dart';

void main() {
  runApp(const NamesScreenApp());
}

class NamesScreenApp extends StatelessWidget {
  const NamesScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NamesScreen(),
    );
  }
}

class NamesScreen extends StatefulWidget {
  const NamesScreen({super.key});

  @override
  _NamesScreenState createState() => _NamesScreenState();
}

class _NamesScreenState extends State<NamesScreen> {
  late Future<List<Name>> _namesFuture;
  List<Name> _names = [];
  bool _isSortedAlphabetically = false;

  @override
  void initState() {
    super.initState();
    _refreshNames();
  }

  void _refreshNames() {
    setState(() {
      _namesFuture = NameTable.getNames();
      _namesFuture.then((names) {
        setState(() {
          _names = names;
        });
      });
    });
  }

  void _sortNamesAlphabetically() {
    setState(() {
      if (!_isSortedAlphabetically) {
        _names.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      } else {
        _refreshNames(); // Vuelve al orden original
      }
      _isSortedAlphabetically = !_isSortedAlphabetically;

    });
  }

  Future<void> _editName(BuildContext context, Name name) async {
    print('Editing name : ${name.name}');
    showDialog(
      context: context,
      builder: (context) => editNamePopUpBuilder(context, name),
    );
  }

  Future<void> _addName(BuildContext context) async {
    print('Adding a new name ');
    showDialog(
      context: context,
      builder: (context) => addNamePopUpBuilder(context),
    );

  }

    Widget addNamePopUpBuilder(context) {
      final TextEditingController nameController = TextEditingController();
      final TextEditingController descriptionController = TextEditingController();
    
      return AlertDialog(
        title: const Text('Añadir Nombre'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
            // texto rojo
            style: TextButton.styleFrom(
              foregroundColor: Colors.red, // Color del texto
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final newName = Name(
                  id: DateTime.now().millisecondsSinceEpoch, // Genera un ID único
                  name: nameController.text,
                  description: descriptionController.text,
                );
                await NameTable.insertName(newName);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nombre añadido')),
                );
                _refreshNames(); // Refresca la lista después de añadir
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al añadir nombre: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary, // Color del botón
              foregroundColor: Colors.white, // Color del texto
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
              ),
            ),
            child: const Text('Guardar'),
          ),

        ],
      );
    }

  Widget editNamePopUpBuilder(BuildContext context, Name name) {
    final TextEditingController nameController = TextEditingController(text: name.name);
    final TextEditingController descriptionController = TextEditingController(text: name.description);

    return AlertDialog(
      title: const Text('Editar Nombre'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Descripción'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red, // Color del texto
          ),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              final updatedName = Name(
                id: name.id,
                name: nameController.text,
                description: descriptionController.text,
              );
              await NameTable.updateName(updatedName.id, updatedName.name, updatedName.description);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nombre actualizado')),
              );
              _refreshNames(); // Refresca la lista después de editar
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al actualizar el nombre: $e')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary, // Color del botón
            foregroundColor: Colors.white, // Color del texto
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Bordes redondeados
            ),
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Future<void> _deleteName(BuildContext context, int id) async {
    print('Deleting name with id: $id');
    try {
      await NameTable.deleteNameById(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nombre eliminado')),
      );
      _refreshNames();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el nombre: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nombres'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              _isSortedAlphabetically ? Icons.sort : Icons.sort_by_alpha,
            ),
            onPressed: _sortNamesAlphabetically,
          ),
        ],
      ),
      body: FutureBuilder<List<Name>>(
        future: _namesFuture,
        builder: nameListBuilder,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addName(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget nameListBuilder(context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay nombres en la base de datos.'));
        } else {
          return ListView.builder(
            itemCount: _names.length,
            itemBuilder: (context, index) {
              final name = _names[index];
              return ListTile(
                title: Text(name.getTitle()),
                subtitle: Text(name.getSubtitle()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editName(context, name),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteName(context, name.id),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
}