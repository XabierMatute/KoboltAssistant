import 'package:flutter/material.dart';
import 'package:caravana_enana/db/title.dart';

void main() {
  runApp(const TitlesScreenApp());
}

class TitlesScreenApp extends StatelessWidget {
  const TitlesScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TitlesScreen(),
    );
  }
}

class TitlesScreen extends StatefulWidget {
  const TitlesScreen({super.key});

  @override
  _TitlesScreenState createState() => _TitlesScreenState();
}

class _TitlesScreenState extends State<TitlesScreen> {
  late Future<List<FantasyTitle>> _titlesFuture;
  List<FantasyTitle> _titles = [];
  bool _isSortedAlphabetically = false;

  @override
  void initState() {
    super.initState();
    _refreshTitles();
  }

  void _refreshTitles() {
    setState(() {
      _titlesFuture = TitleTable.getTitles();
      _titlesFuture.then((titles) {
        setState(() {
          _titles = titles;
        });
      });
    });
  }

  void _sortTitlesAlphabetically() {
    setState(() {
      if (!_isSortedAlphabetically) {
        _titles.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      } else {
        _refreshTitles(); // Vuelve al orden original
      }
      _isSortedAlphabetically = !_isSortedAlphabetically;
    });
  }

  Future<void> _editTitle(BuildContext context, FantasyTitle title) async {
    showDialog(
      context: context,
      builder: (context) => editTitlePopUpBuilder(context, title),
    );
  }

  Future<void> _addTitle(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => addTitlePopUpBuilder(context),
    );
  }

  Widget addTitlePopUpBuilder(context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return AlertDialog(
      title: const Text('Añadir Título'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Título'),
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
          style: TextButton.styleFrom(
            foregroundColor: Colors.red, // Color del texto
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              final newTitle = FantasyTitle(
                id: DateTime.now().millisecondsSinceEpoch, // Genera un ID único
                name: nameController.text,
                description: descriptionController.text,
              );
              await TitleTable.insertTitle(newTitle);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Título añadido')),
              );
              _refreshTitles(); // Refresca la lista después de añadir
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al añadir título: $e')),
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

  Widget editTitlePopUpBuilder(BuildContext context, FantasyTitle title) {
    final TextEditingController nameController = TextEditingController(text: title.name);
    final TextEditingController descriptionController = TextEditingController(text: title.description);

    return AlertDialog(
      title: const Text('Editar Título'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Título'),
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
              final updatedTitle = FantasyTitle(
                id: title.id,
                name: nameController.text,
                description: descriptionController.text,
              );
              await TitleTable.updateTitle(updatedTitle.id, updatedTitle.name, updatedTitle.description);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Título actualizado')),
              );
              _refreshTitles(); // Refresca la lista después de editar
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al actualizar el título: $e')),
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

  Future<void> _deleteTitle(BuildContext context, int id) async {
    try {
      await TitleTable.deleteTitleById(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Título eliminado')),
      );
      _refreshTitles();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el título: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Títulos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              _isSortedAlphabetically ? Icons.sort : Icons.sort_by_alpha,
            ),
            onPressed: _sortTitlesAlphabetically,
          ),
        ],
      ),
      body: FutureBuilder<List<FantasyTitle>>(
        future: _titlesFuture,
        builder: titleListBuilder,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTitle(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget titleListBuilder(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No hay títulos en la base de datos.'));
    } else {
      return ListView.builder(
        itemCount: _titles.length,
        itemBuilder: (context, index) {
          final title = _titles[index];
          return ListTile(
            title: Text(title.name),
            subtitle: Text(title.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editTitle(context, title),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteTitle(context, title.id),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}