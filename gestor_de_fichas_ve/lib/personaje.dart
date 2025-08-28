import 'dart:math';

import 'package:flutter/material.dart';

class AvanceDiferencial {
  // Lista de avance diferencial para Guerrero (AtqDif, PodDif, InsDif)
  static const List<List<int>> guerrero = [
    [0, 0, 0],  // Nivel 1
    [1, 0, 1],  // Nivel 2
    [0, 0, 1],  // Nivel 3
    [1, 0, 1],  // Nivel 4
    [0, 0, 1],  // Nivel 5
    [1, 0, 1],  // Nivel 6
    [1, 0, 1],  // Nivel 7
    [1, 0, 1],  // Nivel 8
    [1, 0, 1],  // Nivel 9
    [1, 0, 1],  // Nivel 10
    [0, 0, 1],  // Nivel 11
    [1, 0, 1],  // Nivel 12
    [1, 0, 0],  // Nivel 13
    [0, 0, 0],  // Nivel 14
  ];

  // Lista de avance diferencial para Hechicero (AtqDif, PodDif, InsDif)
  static const List<List<int>> hechicero = [
    [0, 1, 0],  // Nivel 1
    [0, 1, 1],  // Nivel 2
    [0, 2, 1],  // Nivel 3
    [1, 1, 1],  // Nivel 4
    [0, 2, 1],  // Nivel 5
    [1, 1, 1],  // Nivel 6
    [0, 2, 1],  // Nivel 7
    [1, 2, 1],  // Nivel 8
    [0, 2, 1],  // Nivel 9
    [0, 1, 1],  // Nivel 10
    [1, 2, 1],  // Nivel 11
    [0, 2, 1],  // Nivel 12
    [0, 1, 0],  // Nivel 13
    [1, 2, 0],  // Nivel 14
  ];

  // Lista de avance diferencial para Bribón (AtqDif, PodDif, InsDif)
  static const List<List<int>> bribon = [
    [0, 0, 0],  // Nivel 1
    [0, 0, 1],  // Nivel 2
    [1, 0, 1],  // Nivel 3
    [0, 0, 1],  // Nivel 4
    [1, 0, 1],  // Nivel 5
    [0, 0, 1],  // Nivel 6
    [1, 0, 1],  // Nivel 7
    [0, 0, 1],  // Nivel 8
    [1, 0, 1],  // Nivel 9
    [1, 0, 1],  // Nivel 10
    [0, 0, 1],  // Nivel 11
    [1, 0, 1],  // Nivel 12
    [1, 0, 0],  // Nivel 13
    [0, 0, 0],  // Nivel 14
  ];
}


class Personaje {
  String nombre;
  String raza;
  String clase;

  String? fotopath;

  int nivel;
  int experiencia;
  List<String> experiencias = [];


  List<String> talentos = [];
  List<String> trasfondos = [];

  // Atributos
  int fuerza;
  int destreza;
  int constitucion;
  int inteligencia;
  int sabiduria;
  int carisma;

  // Habilidades
  int alerta = 0;
  int comunicacion = 0;
  int manipulacion = 0;
  int erudicion = 0;
  int subterfugio = 0;
  int supervivencia = 0;

  int puntosVidaActuales = 0;
  int puntosVida;
  int movimiento;
  int defensa = 10;
  int ataque = 0;
  int instintos = 0;
  int poder = 0;

  int oro = 0;
  int plata = 0;
  int cobre = 0;  

  List<String> equipo = [];

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

  static int getModificador(int atributo) {
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

  int get modificadorFuerza => getModificador(fuerza);
  int get modificadorDestreza => getModificador(destreza);
  int get modificadorConstitucion => getModificador(constitucion);
  int get modificadorInteligencia => getModificador(inteligencia);
  int get modificadorSabiduria => getModificador(sabiduria);
  int get modificadorCarisma => getModificador(carisma);


  int get dadoDeAguante {
    if (clase.toLowerCase() == 'guerrero') {
      return 8;
    } else if (clase.toLowerCase() == 'hechicero') {
      return 4;
    } else if (clase.toLowerCase() == 'bribón') {
      return 6;
    } else {
      return 0;
    }
  }

  static Color _hashToColor(String text) {
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
      case 'bribón':
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

  int addExperiencia(String nuevaExperiencia) {
    experiencias.add(nuevaExperiencia);
    return ++experiencia;
  }

  int subirCapDeVida(int subidaDeVida) {
    puntosVida += subidaDeVida;
    puntosVidaActuales += subidaDeVida;
    return puntosVida;
  }

  int mejorarHabilidad(String habilidad) {
    switch (habilidad.toLowerCase()) {
      case 'alerta':
        return ++alerta;
      case 'comunicacion':
        return ++comunicacion;
      case 'manipulacion':
        return ++manipulacion;
      case 'erudicion':
        return ++erudicion;
      case 'subterfugio':
        return ++subterfugio;
      case 'supervivencia':
        return ++supervivencia;
      default:
        throw Exception('Habilidad no reconocida: $habilidad');
    }
  }

  void subirStatsPorNivel() {
    if (nivel >= AvanceDiferencial.guerrero.length) {
      throw Exception('Nivel máximo alcanzado, no se pueden subir más stats.');
    }

    List<int> diffs;
    switch (clase.toLowerCase()) {
      case 'guerrero':
        diffs = AvanceDiferencial.guerrero[nivel - 1];
        break;
      case 'hechicero':
        diffs = AvanceDiferencial.hechicero[nivel - 1];
        break;
      case 'bribón':
        diffs = AvanceDiferencial.bribon[nivel - 1];
        break;
      default:
        throw Exception('Clase no reconocida: $clase');
    }

    ataque += diffs[0];
    poder += diffs[1];
    instintos += diffs[2];
  }

  String _obtenerNuevoTalento6() {
    switch (clase.toLowerCase()) {
      case 'guerrero':
        return 'Ataque Certero';
      case 'hechicero':
        return 'Sirviente Animal';
      case 'bribón':
        return 'Leer Magia';
      default:
        return 'Talento Genérico';
    }
  }

  int subirDeNivel({int? subidaDeVida, List<String>? habilidadesASubir}) {
    if (experiencia < 10) {
      throw Exception('No se puede subir de nivel, experiencia insuficiente.');
    }
    if (habilidadesASubir != null && habilidadesASubir.length > 2) {
      throw Exception('Solo se pueden subir hasta 2 habilidades por nivel.');
    }
    if (habilidadesASubir != null && habilidadesASubir.length == 2 && habilidadesASubir[0].toLowerCase() == habilidadesASubir[1].toLowerCase()) {
      throw Exception('No se pueden subir la misma habilidad dos veces.');
    }
    subidaDeVida ??= Random().nextInt(dadoDeAguante) + 1;
    subirCapDeVida(subidaDeVida);

    for (var habilidad in habilidadesASubir ?? []) { 
      if (mejorarHabilidad(habilidad) > 10) {
        throw Exception('No se puede subir la habilidad $habilidad más allá de 10.');
      }
    }

    subirStatsPorNivel();

    if (nivel == 5) {
      talentos.add(_obtenerNuevoTalento6());
    }


    experiencia -= 10; 
    return ++nivel;
  }
}