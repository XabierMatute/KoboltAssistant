import 'dart:math';

import 'package:flutter/material.dart';
import 'personaje.dart';

class CharacterSheet extends StatefulWidget {
  final Personaje personaje;

  const CharacterSheet({
    super.key,
    required this.personaje,
  });

  @override
  State<CharacterSheet> createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.personaje.nombre),
        backgroundColor: widget.personaje.classColor,
        foregroundColor: Colors.white,
      ),
    floatingActionButton: widget.personaje.experiencia >= 10
        ? FloatingActionButton.extended(
            onPressed: _subirNivel,
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.arrow_upward),
            label: const Text('¡Subir Nivel!'),
          )
        : FloatingActionButton.extended(
            onPressed: _anadirExperiencia,
            backgroundColor: widget.personaje.classColor,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Experiencia'),
          ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInfo(),
            const SizedBox(height: 16),
            _buildAttributes(),
            const SizedBox(height: 16),
            _buildSkills(),
            const SizedBox(height: 16),
            _buildTalentos(),
            const SizedBox(height: 16),
            _buildTrasfondos(),
            const SizedBox(height: 16),
            _buildCombat(),
            const SizedBox(height: 16),
            _buildMoney(),
            const SizedBox(height: 16),
            _buildExperiences(),
            const SizedBox(height: 16),
            _buildEquipment(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }


void _anadirExperiencia() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final TextEditingController controller = TextEditingController();
      
      void anadirYCerrar() {
        final texto = controller.text.trim();
        if (texto.isNotEmpty) {
          setState(() {
            widget.personaje.addExperiencia(texto);
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('¡Experiencia añadida! XP: ${widget.personaje.experiencia}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
      
      return AlertDialog(
        title: const Text('Nueva Experiencia'),
        content: TextField(
          controller: controller,
          onSubmitted: (_) => anadirYCerrar(), 
          decoration: const InputDecoration(
            hintText: 'Describe la experiencia... (Enter para añadir)',
            border: OutlineInputBorder(),
          ),
          maxLines: 1, // ✅ ESTA ES LA CLAVE: UNA SOLA LÍNEA
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: anadirYCerrar,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.personaje.classColor, 
              foregroundColor: Colors.white
            ),
            child: const Text('Añadir'),
          ),
        ],
      );
    },
  );
}

// En _CharacterSheetState, añade este método después de _anadirExperiencia()

void _subirNivel() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String? habilidadSeleccionada;
      int? puntosVidaGanados;
      
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.arrow_upward, color: widget.personaje.classColor),
                const SizedBox(width: 8),
                const Text('¡Subir de Nivel!'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.celebration,
                    size: 64,
                    color: widget.personaje.classColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nivel ${widget.personaje.nivel} → ${widget.personaje.nivel + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  
                  // Selección de habilidad
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mejorar Habilidad:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: habilidadSeleccionada,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Selecciona una habilidad...',
                            isDense: true,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'alerta', child: Text('Alerta')),
                            DropdownMenuItem(value: 'comunicacion', child: Text('Comunicación')),
                            DropdownMenuItem(value: 'manipulacion', child: Text('Manipulación')),
                            DropdownMenuItem(value: 'erudicion', child: Text('Erudición')),
                            DropdownMenuItem(value: 'subterfugio', child: Text('Subterfugio')),
                            DropdownMenuItem(value: 'supervivencia', child: Text('Supervivencia')),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              habilidadSeleccionada = value;
                            });
                          },
                        ),
                        if (habilidadSeleccionada != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Valor actual: ${_getHabilidadValue(habilidadSeleccionada!)} → ${_getHabilidadValue(habilidadSeleccionada!) + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Dados de vida
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Puntos de Vida:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  puntosVidaGanados = Random().nextInt(widget.personaje.dadoDeAguante) + 1;
                                });
                              },
                              icon: const Icon(Icons.casino, size: 16),
                              label: Text('Tirar d${widget.personaje.dadoDeAguante}'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                        if (puntosVidaGanados != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '¡Ganaste $puntosVidaGanados puntos de vida!',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            'Vida: ${widget.personaje.puntosVida} → ${widget.personaje.puntosVida + puntosVidaGanados!}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: (habilidadSeleccionada != null && puntosVidaGanados != null)
                    ? () {
                        try {
                          // ✅ USAR EL MÉTODO REAL DEL PERSONAJE
                          widget.personaje.subirDeNivel(
                            subidaDeVida: puntosVidaGanados!,
                            habilidadesASubir: [habilidadSeleccionada!],
                          );
                          
                          Navigator.pop(context);
                          
                          // Actualizar la UI principal
                          this.setState(() {});
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '¡Nivel ${widget.personaje.nivel}! +$puntosVidaGanados HP, ${habilidadSeleccionada!.toUpperCase()} mejorada',
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.personaje.classColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('¡Subir Nivel!'),
              ),
            ],
          );
        },
      );
    },
  );
}

// Método helper para obtener el valor actual de una habilidad
int _getHabilidadValue(String habilidad) {
  switch (habilidad.toLowerCase()) {
    case 'alerta':
      return widget.personaje.alerta;
    case 'comunicacion':
      return widget.personaje.comunicacion;
    case 'manipulacion':
      return widget.personaje.manipulacion;
    case 'erudicion':
      return widget.personaje.erudicion;
    case 'subterfugio':
      return widget.personaje.subterfugio;
    case 'supervivencia':
      return widget.personaje.supervivencia;
    default:
      return 0;
  }
}


// También modifica _buildBasicInfo() para mostrar un indicador visual:

Widget _buildBasicInfo() {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Información Básica', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildInfoRow('Nombre', widget.personaje.nombre),
          _buildInfoRow('Raza', widget.personaje.raza),
          _buildInfoRow('Clase', widget.personaje.clase),
          _buildInfoRow('Nivel', '${widget.personaje.nivel}'),
          
          // XP con indicador especial si puede subir nivel
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const SizedBox(
                  width: 120,
                  child: Text('Experiencia:', style: TextStyle(fontWeight: FontWeight.w500)),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text('${widget.personaje.experiencia} XP'),
                      if (widget.personaje.experiencia >= 10) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '¡NIVEL UP!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          _buildInfoRow('Dado de Aguante', 'd${widget.personaje.dadoDeAguante}'),
        ],
      ),
    ),
  );
}


  Widget _buildAttributes() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Atributos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildAttributeBox('FUE', widget.personaje.fuerza, widget.personaje.modificadorFuerza)),
                const SizedBox(width: 8),
                Expanded(child: _buildAttributeBox('DES', widget.personaje.destreza, widget.personaje.modificadorDestreza)),
                const SizedBox(width: 8),
                Expanded(child: _buildAttributeBox('CON', widget.personaje.constitucion, widget.personaje.modificadorConstitucion)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildAttributeBox('INT', widget.personaje.inteligencia, widget.personaje.modificadorInteligencia)),
                const SizedBox(width: 8),
                Expanded(child: _buildAttributeBox('SAB', widget.personaje.sabiduria, widget.personaje.modificadorSabiduria)),
                const SizedBox(width: 8),
                Expanded(child: _buildAttributeBox('CAR', widget.personaje.carisma, widget.personaje.modificadorCarisma)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeBox(String name, int value, int modifier) {
    String modifierText = modifier >= 0 ? '+$modifier' : '$modifier';
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('$value', style: const TextStyle(fontSize: 18)),
          Text(modifierText, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildSkills() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Habilidades', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildInfoRow('Alerta', '${widget.personaje.alerta}'),
            _buildInfoRow('Comunicación', '${widget.personaje.comunicacion}'),
            _buildInfoRow('Manipulación', '${widget.personaje.manipulacion}'),
            _buildInfoRow('Erudición', '${widget.personaje.erudicion}'),
            _buildInfoRow('Subterfugio', '${widget.personaje.subterfugio}'),
            _buildInfoRow('Supervivencia', '${widget.personaje.supervivencia}'),
          ],
        ),
      ),
    );
  }

  Widget _buildTalentos() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Talentos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (widget.personaje.talentos.isEmpty)
              const Text('No hay talentos registrados', style: TextStyle(color: Colors.grey))
            else
              ...widget.personaje.talentos.map((talento) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(talento, style: const TextStyle(fontWeight: FontWeight.w500))),
                  ],
                ),
              )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrasfondos() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Trasfondos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (widget.personaje.trasfondos.isEmpty)
              const Text('No hay trasfondos registrados', style: TextStyle(color: Colors.grey))
            else
              ...widget.personaje.trasfondos.map((trasfondo) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.history_edu, color: Colors.blue[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(trasfondo, style: const TextStyle(fontWeight: FontWeight.w500))),
                  ],
                ),
              )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCombat() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Combate', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildInfoRow('Puntos de Vida', '${widget.personaje.puntosVidaActuales} / ${widget.personaje.puntosVida}'),
            _buildInfoRow('Movimiento', '${widget.personaje.movimiento}'),
            _buildInfoRow('Defensa', '${widget.personaje.defensa}'),
            _buildInfoRow('Ataque', '${widget.personaje.ataque}'),
            _buildInfoRow('Instintos', '${widget.personaje.instintos}'),
            _buildInfoRow('Poder', '${widget.personaje.poder}'),
          ],
        ),
      ),
    );
  }

  Widget _buildMoney() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dinero', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCoinBox('ORO', widget.personaje.oro, Colors.amber),
                _buildCoinBox('PLATA', widget.personaje.plata, Colors.grey),
                _buildCoinBox('COBRE', widget.personaje.cobre, Colors.brown),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinBox(String name, int amount, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              '$amount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color.withOpacity(0.8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildExperiences() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Experiencias (${widget.personaje.experiencias.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: _anadirExperiencia,
                  icon: Icon(Icons.add_circle, color: widget.personaje.classColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.personaje.experiencias.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.auto_stories, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text('No hay experiencias registradas', style: TextStyle(color: Colors.grey[600])),
                      Text('¡Añade tu primera aventura!', style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              )
            else
              ...widget.personaje.experiencias.asMap().entries.map((entry) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.green[600],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(entry.value)),
                  ],
                ),
              )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipment() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Equipo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (widget.personaje.equipo.isEmpty)
              const Text('No hay equipo registrado', style: TextStyle(color: Colors.grey))
            else
              ...widget.personaje.equipo.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.inventory, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item)),
                  ],
                ),
              )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Character Sheet Test',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: CharacterSheet(
        personaje: Personaje(
          nombre: 'Aragorn',
          raza: 'Humano',
          clase: 'Guerrero',
          nivel: 5,
          experiencia: 9,
          fuerza: 16,
          destreza: 14,
          constitucion: 15,
          inteligencia: 12,
          sabiduria: 13,
          carisma: 14,
          puntosVida: 45,
          oro: 50,
          plata: 23,
          cobre: 157,
          talentos: ['Combate con dos armas', 'Liderazgo'],
          trasfondos: ['Noble exiliado', 'Montaraz del Norte'],
          equipo: ['Andúril', 'Armadura de cuero', 'Arco largo'],
        ),
      ),
    );
  }
}