import 'package:flutter/material.dart';
import 'personaje.dart';

class CharacterCard extends StatelessWidget {
  final Personaje personaje;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const CharacterCard({
    super.key,
    required this.personaje,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 200,
        height: height ?? 280,
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
        child: Column(
          children: [
            // Foto del personaje
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(16),
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
                child: ClipOval(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey[300],
                    child: personaje.fotopath != null
                        ? Image.asset(
                            personaje.fotopath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              );
                            },
                          )
                        : const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),
            ),
            
            // Información del personaje
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Nombre
                    Text(
                      personaje.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Nivel
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Nivel ${personaje.nivel}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterCardCompact extends StatelessWidget {
  final Personaje personaje;
  final VoidCallback? onTap;

  const CharacterCardCompact({
    super.key,
    required this.personaje,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: personaje.gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Foto pequeña
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: personaje.fotopath != null
                      ? ClipOval(
                          child: Image.asset(
                            personaje.fotopath!,
                            fit: BoxFit.cover,
                            width: 56,
                            height: 56,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person, size: 30, color: Colors.grey);
                            },
                          ),
                        )
                      : const Icon(Icons.person, size: 30, color: Colors.grey),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      personaje.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nivel ${personaje.nivel}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Icono de flecha (opcional)
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// MAIN PARA PROBAR POR SEPARADO
void main() {
  runApp(const CharacterCardTestApp());
}

class CharacterCardTestApp extends StatelessWidget {
  const CharacterCardTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Character Card Test',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        useMaterial3: true,
      ),
      home: const CharacterCardTestPage(),
    );
  }
}

class CharacterCardTestPage extends StatelessWidget {
  const CharacterCardTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Personajes de prueba
    final List<Personaje> personajes = [
      Personaje(
        nombre: 'Aragorn',
        raza: 'Humano',
        clase: 'Guerrero',
        nivel: 8,
        fotopath: "assets/jestie.jpg",
      ),
      Personaje(
        nombre: 'Legolas',
        raza: 'Elfo',
        clase: 'Bribón',
        nivel: 7,
        fotopath: null,
      ),
      Personaje(
        nombre: 'Gandalf',
        raza: 'Maiar',
        clase: 'Hechicero',
        nivel: 20,
        fotopath: null,
      ),
      Personaje(
        nombre: 'Gimli',
        raza: 'Enano',
        clase: 'Guerrero',
        nivel: 6,
        fotopath: null,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Character Card Test'),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              'Tarjetas Verticales',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 16),
            
            // Grid de tarjetas verticales
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: personajes.length,
              itemBuilder: (context, index) {
                return CharacterCard(
                  personaje: personajes[index],
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('¡Has tocado ${personajes[index].nombre}!'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Título para tarjetas compactas
            Text(
              'Tarjetas Compactas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 16),
            
            // Lista de tarjetas compactas
            ...personajes.map((personaje) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CharacterCardCompact(
                  personaje: personaje,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('¡Has tocado ${personaje.nombre} (compacta)!'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
            ).toList(),
            
            const SizedBox(height: 32),
            
            // Botón de prueba
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('¡Funciona!'),
                      content: const Text('Las tarjetas de personaje están funcionando correctamente.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Probar Dialog'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}