import 'package:flutter/material.dart';
import 'package:caravana_enana/db/dwarf.dart';

class DwarvesScreen extends StatefulWidget {
  const DwarvesScreen({super.key});

  @override
  _DwarvesScreenState createState() => _DwarvesScreenState();
}

class _DwarvesScreenState extends State<DwarvesScreen> {
  late Future<List<Dwarf>> _dwarvesFuture;
  List<Dwarf> _dwarves = [];
  bool _isSortedAlphabetically = false;

  @override
  void initState() {
    super.initState();
    _refreshDwarves();
  }

  void _refreshDwarves() {
    setState(() {
      _dwarvesFuture = DwarfTable.getDwarves();
      _dwarvesFuture.then((dwarves) {
        setState(() {
          _dwarves = dwarves;
        });
      });
    });
  }

  void _sortDwarvesAlphabetically() {
    setState(() {
      if (!_isSortedAlphabetically) {
        _dwarves.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      } else {
        _refreshDwarves(); // Vuelve al orden original
      }
      _isSortedAlphabetically = !_isSortedAlphabetically;
    });
  }

  Future<void> _deleteDwarf(BuildContext context, int id) async {
    try {
      await DwarfTable.deleteDwarfById(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enano eliminado')),
      );
      _refreshDwarves();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el enano: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enanos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              _isSortedAlphabetically ? Icons.sort : Icons.sort_by_alpha,
            ),
            onPressed: _sortDwarvesAlphabetically,
          ),
        ],
      ),
      body: FutureBuilder<List<Dwarf>>(
        future: _dwarvesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay enanos en la base de datos.'));
          } else {
            return ListView.builder(
              itemCount: _dwarves.length,
              itemBuilder: (context, index) {
                final dwarf = _dwarves[index];
                return ListTile(
                  title: Text(dwarf.name),
                  subtitle: Text(dwarf.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteDwarf(context, dwarf.id),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DwarvesScreen(),
  ));
}