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

  Color _hashToColor(String text) {
    int hash = text.toLowerCase().hashCode;
    
    // Extraer componentes RGB del hash
    int r = (hash & 0xFF0000) >> 16;
    int g = (hash & 0x00FF00) >> 8;
    int b = hash & 0x0000FF;
    
    // Ajustar para que los colores no sean demasiado oscuros o claros
    r = ((r * 0.7) + 80).round().clamp(80, 200);
    g = ((g * 0.7) + 80).round().clamp(80, 200);
    b = ((b * 0.7) + 80).round().clamp(80, 200);
    
    return Color.fromARGB(255, r, g, b);
  }

  Color get classColor {
    switch (clase.toLowerCase()) {
      case 'guerrero':
        // Rojo sangre
        return const Color.fromRGBO(139, 0, 0, 1);

      case 'hechicero':
        // Color azul magico
        return const Color.fromRGBO(0, 0, 255, 1);

      case 'pícaro':
        // Negro Sombra
        return const Color.fromRGBO(0, 0, 0, 1);

      default:
        return _hashToColor(clase);
    }
  }

  Color get raceColor {
    switch (raza.toLowerCase()) {
      case 'enano':
      // Gris piedra
      return const Color.fromRGBO(105, 105, 105, 1);
      case 'elfo':
      // Amarillo radiante
        return const Color.fromRGBO(255, 215, 0, 1);
      case 'humano':
      // rosa carne
        return const Color.fromRGBO(255, 182, 193, 1);
      case 'mediano':
      // Naranja jobial
        return const Color.fromRGBO(255, 140, 0, 1);
      default:
        return _hashToColor(raza);
    }
  }

  List<Color> get gradientColors {
    return [classColor, raceColor];
  }
}

void main() {
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Gestor de Fichas',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
//         useMaterial3: true,
//       ),
//       home: const FichaPersonajePage(),
//     );
//   }
// }

// Modifica MyApp para agregar un botón de debug
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
      home: const HomePage(),
    );
  }
}

// Nueva página de inicio con navegación
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        title: const Text('Gestor de Fichas'),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón principal
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FichaPersonajePage()),
                  );
                },
                icon: const Icon(Icons.person),
                label: const Text('Ver Ficha Principal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Botón de debug
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DebugPersonajesPage()),
                  );
                },
                icon: const Icon(Icons.bug_report),
                label: const Text('Debug - Ver Todos los Personajes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
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
  final Personaje asgalean = Personaje(
    nombre: 'Asier Galean',
    raza: 'Putero',
    clase: 'Mago',
    fotopath: 'assets/jestie.jpg',
  );

  // @override
  // void initState() {
  //   super.initState();
  //   // Personaje de ejemplo
  //   personaje = Personaje(
  //     fotopath: 'assets/jestie.jpg',
  //     nombre: 'Thorin Escudodorado',
  //     raza: 'Enano',
  //     clase: 'Guerrero',
  //     nivel: 3,
  //     experiencia: 7,
  //     fuerza: 16,
  //     destreza: 12,
  //     constitucion: 15,
  //     inteligencia: 10,
  //     sabiduria: 13,
  //     carisma: 8,
  //     puntosVida: 28,
  //     oro: 150,
  //     plata: 25,
  //     cobre: 80,
  //     equipo: ['Hacha de guerra', 'Armadura de mallas', 'Escudo', 'Mochila'],
  //     talentos: ['Combate con dos armas', 'Resistencia enana'],
  //     trasfondos: ['Herrero', 'Soldado'],
  //   );
  // }

  @override
  void initState() {
    super.initState();
    personaje = asgalean;
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
    return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: personaje.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
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
                          color: Colors.black.withValues(alpha: 0.3),
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
                        Row(
                          children: [
                            _buildInfoChip(personaje.clase),
                            const SizedBox(width: 4),
                            _buildInfoChip(personaje.raza),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildInfoChip('Nivel ${personaje.nivel}'),
                            const SizedBox(width: 4),
                            _buildInfoChip('${personaje.experiencia} XP'),
                          ],
                        ),
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
        color: Colors.white.withValues(alpha: 0.2),
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

// Agrega esta nueva página después de la clase _FichaPersonajePageState

class DebugPersonajesPage extends StatelessWidget {
  const DebugPersonajesPage({super.key});

  @override
  Widget build(BuildContext context) {

    // Lista de personajes de prueba
    final List<Personaje> personajes = [
      // Personaje(
      //   nombre: 'Thorin primero',
      //   raza: 'Enano1',
      //   clase: 'Guerrero',
      // ),
      // Personaje(
      //   nombre: 'Thorin segundo',
      //   raza: 'Enano2',
      //   clase: 'Guerrero',
      // ),
      // Personaje(
      //   nombre: 'Thorin tercero',
      //   raza: 'Enano3',
      //   clase: 'Guerrero',
      // ),
      // Personaje(
      //   nombre: 'Thorin cuarto',
      //   raza: 'Enano4',
      //   clase: 'Guerrero',
      // ),
      Personaje(
        nombre: 'Thorin Escudodorado',
        raza: 'Enano',
        clase: 'Guerrero',
        nivel: 5,
        experiencia: 1200,
        fotopath: null,
      ),
      Personaje(
        nombre: 'Asier Galean',
        raza: 'Humano',
        clase: 'Mago',
        nivel: 3,
        experiencia: 850,
        fotopath: 'assets/jestie.jpg',
      ),
      Personaje(
        nombre: 'Luna Sombraluna',
        raza: 'Elfo',
        clase: 'Pícaro',
        nivel: 4,
        experiencia: 1000,
        fotopath: null,
      ),
      Personaje(
        nombre: 'Frodo Bolsón',
        raza: 'Mediano',
        clase: 'Explorador',
        nivel: 2,
        experiencia: 500,
        fotopath: null,
      ),
      Personaje(
        nombre: 'Gandalf el Gris',
        raza: 'Maiar',
        clase: 'Hechicero',
        nivel: 20,
        experiencia: 50000,
        fotopath: null,
      ),
      Personaje(
        nombre: 'Aragorn',
        raza: 'Dúnadan',
        clase: 'Montaraz',
        nivel: 8,
        experiencia: 3500,
        fotopath: null,
      ),
      Personaje(
        nombre: 'Legolas',
        raza: 'Elfo',
        clase: 'Arquero',
        nivel: 7,
        experiencia: 2800,
        fotopath: null,
      ),
      Personaje(
        nombre: 'Gimli',
        raza: 'Enano',
        clase: 'Berserker',
        nivel: 6,
        experiencia: 2100,
        fotopath: null,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        title: const Text('Debug - Personajes'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Galería de Personajes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 16),
            
            // Grid de tarjetas de personajes
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3.5,
                mainAxisSpacing: 16,
              ),
              itemCount: personajes.length,
              itemBuilder: (context, index) {
                final personaje = personajes[index];
                return _buildPersonajeCard(personaje, context);
              },
            ),
            
            const SizedBox(height: 20),
            
            // Sección de estadísticas de colores
            Text(
              'Estadísticas de Colores',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 16),
            
            _buildColorStats(personajes),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonajeCard(Personaje personaje, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: personaje.gradientColors,
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
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Avatar del personaje
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                child: personaje.fotopath != null
                    ? ClipOval(
                        child: Image.asset(
                          personaje.fotopath!,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, size: 30, color: Colors.grey);
                          },
                        ),
                      )
                    : const Icon(Icons.person, size: 30, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            
            // Información del personaje
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    personaje.nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _buildInfoChip('${personaje.clase} ${personaje.raza}'),
                  const SizedBox(height: 4),
                  _buildInfoChip('Nivel ${personaje.nivel} • ${personaje.experiencia} XP'),
                ],
              ),
            ),
            
            // Colores de muestra
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: personaje.classColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
                const SizedBox(height: 4),
                const Text('Clase', style: TextStyle(color: Colors.white, fontSize: 10)),
                const SizedBox(height: 8),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: personaje.raceColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
                const SizedBox(height: 4),
                const Text('Raza', style: TextStyle(color: Colors.white, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildColorStats(List<Personaje> personajes) {
    Map<String, List<Personaje>> clases = {};
    Map<String, List<Personaje>> razas = {};
    
    for (var personaje in personajes) {
      clases.putIfAbsent(personaje.clase, () => []).add(personaje);
      razas.putIfAbsent(personaje.raza, () => []).add(personaje);
    }
    
    return Column(
      children: [
        // Estadísticas de clases
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Clases',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: clases.entries.map((entry) {
                    final clase = entry.key;
                    final count = entry.value.length;
                    final color = entry.value.first.classColor;
                    
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: color),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('$clase ($count)'),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Estadísticas de razas
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Razas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: razas.entries.map((entry) {
                    final raza = entry.key;
                    final count = entry.value.length;
                    final color = entry.value.first.raceColor;
                    
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: color),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('$raza ($count)'),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

