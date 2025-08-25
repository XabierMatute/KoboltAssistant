import 'package:flutter/material.dart';

class Personaje {
  String nombre;
  String raza;
  String clase;

  String? fotopath;

  int nivel;
  int experiencia;
  List<String> talentos;
  List<String> trasfondos;

  // Atributos
  int fuerza;
  int destreza;
  int constitucion;
  int inteligencia;
  int sabiduria;
  int carisma;

  // Habilidades
  int alerta;
  int comunicacion;
  int manipulacion;
  int erudicion;
  int subterfugio;
  int supervivencia;

  int puntosVida;
  int movimiento;
  int defensa;
  int ataque;
  int instintos;
  int poder;

  int oro;
  int plata;
  int cobre;

  List<String> equipo;

  Personaje({
    required this.nombre,
    required this.raza,
    required this.clase,
    this.fotopath,
    this.nivel = 1,
    this.experiencia = 0,
    this.talentos = const [],
    this.trasfondos = const [],
    this.fuerza = 10,
    this.destreza = 10,
    this.constitucion = 10,
    this.inteligencia = 10,
    this.sabiduria = 10,
    this.carisma = 10,
    this.alerta = 0,
    this.comunicacion = 0,
    this.manipulacion = 0,
    this.erudicion = 0,
    this.subterfugio = 0,
    this.supervivencia = 0,
    this.puntosVida = 10,
    this.movimiento = 30,
    this.defensa = 10,
    this.ataque = 5,
    this.instintos = 5,
    this.poder = 0,
    this.oro = 0,
    this.plata = 0,
    this.cobre = 0,
    this.equipo = const [],
  });

  int getModificador(int atributo) {
    final valor = atributo;
    if (valor < 3) return -3;
    if (valor == 3) return -2;
    if (valor >= 4 && valor <= 6) return -1;
    if (valor >= 7 && valor <= 14) return 0;
    if (valor >= 15 && valor <= 17) return 1;
    if (valor == 18) return 2;
    if (valor > 18) return 3;
    return 0;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Fichas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const FichaPersonajePage(),
    );
  }
}

class FichaPersonajePage extends StatefulWidget {
  const FichaPersonajePage({super.key});

  @override
  State<FichaPersonajePage> createState() => _FichaPersonajePageState();
}

class _FichaPersonajePageState extends State<FichaPersonajePage> {
  late Personaje personaje;

  @override
  void initState() {
    super.initState();
    // Personaje de ejemplo
    personaje = Personaje(
      fotopath: 'assets/jestie.jpg',
      nombre: 'Thorin Escudodorado',
      raza: 'Enano',
      clase: 'Guerrero',
      nivel: 3,
      experiencia: 7,
      fuerza: 16,
      destreza: 12,
      constitucion: 15,
      inteligencia: 10,
      sabiduria: 13,
      carisma: 8,
      puntosVida: 28,
      oro: 150,
      plata: 25,
      cobre: 80,
      equipo: ['Hacha de guerra', 'Armadura de mallas', 'Escudo', 'Mochila'],
      talentos: ['Combate con dos armas', 'Resistencia enana'],
      trasfondos: ['Herrero', 'Soldado'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        title: Text('Ficha de ${personaje.nombre}'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con foto e información básica
            mainInfoWidgetBuilder(),
            const SizedBox(height: 20),

            // // Atributos principales
            // _buildSectionCard(
            //   'Atributos',
            //   Icons.fitness_center,
            //   Colors.red,
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Column(
            //           children: [
            //             _buildAtributoCard('FUE', personaje.fuerza, Colors.red[100]!),
            //             const SizedBox(height: 8),
            //             _buildAtributoCard('DES', personaje.destreza, Colors.green[100]!),
            //             const SizedBox(height: 8),
            //             _buildAtributoCard('CON', personaje.constitucion, Colors.orange[100]!),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(width: 16),
            //       Expanded(
            //         child: Column(
            //           children: [
            //             _buildAtributoCard('INT', personaje.inteligencia, Colors.blue[100]!),
            //             const SizedBox(height: 8),
            //             _buildAtributoCard('SAB', personaje.sabiduria, Colors.purple[100]!),
            //             const SizedBox(height: 8),
            //             _buildAtributoCard('CAR', personaje.carisma, Colors.pink[100]!),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // // Estadísticas de combate
            // _buildSectionCard(
            //   'Combate',
            //   Icons.local_fire_department,
            //   Colors.orange,
            //   child: Row(
            //     children: [
            //       Expanded(child: _buildStatCard('PV', personaje.puntosVida, Icons.favorite, Colors.red)),
            //       const SizedBox(width: 8),
            //       Expanded(child: _buildStatCard('DEF', personaje.defensa, Icons.shield, Colors.blue)),
            //       const SizedBox(width: 8),
            //       Expanded(child: _buildStatCard('ATQ', personaje.ataque, Icons.sports_martial_arts, Colors.orange)),
            //       const SizedBox(width: 8),
            //       Expanded(child: _buildStatCard('MOV', personaje.movimiento, Icons.directions_run, Colors.green)),
            //     ],
            //   ),
            // ),

            // // Dinero
            // _buildSectionCard(
            //   'Riquezas',
            //   Icons.monetization_on,
            //   Colors.amber,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       _buildMoneyCard('Oro', personaje.oro, Colors.amber, Icons.circle),
            //       _buildMoneyCard('Plata', personaje.plata, Colors.grey, Icons.circle),
            //       _buildMoneyCard('Cobre', personaje.cobre, Colors.brown, Icons.circle),
            //     ],
            //   ),
            // ),

            // // Equipo
            // _buildSectionCard(
            //   'Equipo',
            //   Icons.inventory,
            //   Colors.brown,
            //   child: Wrap(
            //     spacing: 8,
            //     runSpacing: 8,
            //     children: personaje.equipo.map((item) => 
            //       Container(
            //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            //         decoration: BoxDecoration(
            //           color: Colors.brown[50],
            //           borderRadius: BorderRadius.circular(20),
            //           border: Border.all(color: Colors.brown[300]!),
            //         ),
            //         child: Text(
            //           item,
            //           style: TextStyle(
            //             color: Colors.brown[700],
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //       ),
            //     ).toList(),
            //   ),
            // ),

            // // Talentos y Trasfondos
            // if (personaje.talentos.isNotEmpty)
            //   _buildSectionCard(
            //     'Talentos',
            //     Icons.stars,
            //     Colors.purple,
            //     child: Column(
            //       children: personaje.talentos.map((talento) => 
            //         Padding(
            //           padding: const EdgeInsets.symmetric(vertical: 4),
            //           child: Row(
            //             children: [
            //               Icon(Icons.star, color: Colors.purple[600], size: 20),
            //               const SizedBox(width: 8),
            //               Expanded(child: Text(talento)),
            //             ],
            //           ),
            //         ),
            //       ).toList(),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  Container mainInfoWidgetBuilder() {
    Color bgColor1 = Colors.brown[700]!;
    Color bgColor2 = Colors.brown[500]!;

    if (personaje.clase == 'Guerrero') {
      bgColor1 = const Color.fromARGB(255, 255, 0, 0)!;
    } else if (personaje.clase == 'Mago') {
      bgColor1 = Colors.blue[700]!;
      bgColor2 = Colors.blue[500]!;
    } else if (personaje.clase == 'Pícaro') {
      bgColor1 = Colors.green[700]!;
      bgColor2 = Colors.green[500]!;
    }
    return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [bgColor1, bgColor2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Avatar del personaje
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      child: personaje.fotopath != null
                          ? ClipOval(
                              child: Image.asset(
                                personaje.fotopath!,
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error cargando imagen: $error');
                                  return const Icon(Icons.person, size: 40, color: Colors.grey);
                                },
                              ),
                            )
                          : const Icon(Icons.person, size: 40, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Información básica
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          personaje.nombre,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoChip('${personaje.raza} ${personaje.clase}'),
                        const SizedBox(height: 4),
                        _buildInfoChip('Nivel ${personaje.nivel} • ${personaje.experiencia} XP'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, Color color, {required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildAtributoCard(String nombre, int valor, Color bgColor) {
    int modificador = personaje.getModificador(valor);
    String signo = modificador >= 0 ? '+' : '';
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bgColor.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            nombre,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valor.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '($signo$modificador)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyCard(String tipo, int cantidad, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          cantidad.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          tipo,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAtributo(String nombre, int valor) {
    int modificador = personaje.getModificador(valor);
    String signo = modificador >= 0 ? '+' : '';
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(nombre),
          Text('$valor ($signo$modificador)'),
        ],
      ),
    );
  }
}