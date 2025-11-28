// ignore_for_file: avoid_print
import 'dart:math';
import 'dart:io';

/// =========================
///        DATOS (Type Chart)
/// =========================

class TablaTipos {
  // Mapa de efectividad: Atacante -> Defensor -> Multiplicador
  static final Map<String, Map<String, double>> efectividad = {
    'Normal': {'Roca': 0.5, 'Fantasma': 0.0, 'Acero': 0.5},
    'Fuego': {'Fuego': 0.5, 'Agua': 0.5, 'Hierba': 2.0, 'Hielo': 2.0, 'Bicho': 2.0, 'Roca': 0.5, 'Dragon': 0.5, 'Acero': 2.0},
    'Agua': {'Fuego': 2.0, 'Agua': 0.5, 'Hierba': 0.5, 'Tierra': 2.0, 'Roca': 2.0, 'Dragon': 0.5},
    'Hierba': {'Fuego': 0.5, 'Agua': 2.0, 'Hierba': 0.5, 'Veneno': 0.5, 'Tierra': 2.0, 'Volador': 0.5, 'Bicho': 0.5, 'Roca': 2.0, 'Dragon': 0.5, 'Acero': 0.5},
    'Electrico': {'Agua': 2.0, 'Hierba': 0.5, 'Electrico': 0.5, 'Tierra': 0.0, 'Volador': 2.0, 'Dragon': 0.5},
    'Hielo': {'Fuego': 0.5, 'Agua': 0.5, 'Hierba': 2.0, 'Hielo': 0.5, 'Tierra': 2.0, 'Volador': 2.0, 'Dragon': 2.0, 'Acero': 0.5},
    'Lucha': {'Normal': 2.0, 'Hielo': 2.0, 'Veneno': 0.5, 'Volador': 0.5, 'Psiquico': 0.5, 'Bicho': 0.5, 'Roca': 2.0, 'Fantasma': 0.0, 'Oscuro': 2.0, 'Acero': 2.0},
    'Veneno': {'Hierba': 2.0, 'Veneno': 0.5, 'Tierra': 0.5, 'Roca': 0.5, 'Fantasma': 0.5, 'Acero': 0.0},
    'Tierra': {'Fuego': 2.0, 'Hierba': 0.5, 'Electrico': 2.0, 'Veneno': 2.0, 'Volador': 0.0, 'Bicho': 0.5, 'Roca': 2.0, 'Acero': 2.0},
    'Volador': {'Hierba': 2.0, 'Electrico': 0.5, 'Lucha': 2.0, 'Bicho': 2.0, 'Roca': 0.5, 'Acero': 0.5},
    'Psiquico': {'Lucha': 2.0, 'Veneno': 2.0, 'Psiquico': 0.5, 'Oscuro': 0.0, 'Acero': 0.5},
    'Bicho': {'Fuego': 0.5, 'Hierba': 2.0, 'Lucha': 0.5, 'Veneno': 0.5, 'Volador': 0.5, 'Psiquico': 2.0, 'Fantasma': 0.5, 'Oscuro': 2.0, 'Acero': 0.5},
    'Roca': {'Fuego': 2.0, 'Hielo': 2.0, 'Lucha': 0.5, 'Tierra': 0.5, 'Volador': 2.0, 'Bicho': 2.0, 'Acero': 0.5},
    'Fantasma': {'Normal': 0.0, 'Psiquico': 2.0, 'Fantasma': 2.0, 'Oscuro': 0.5},
    'Dragon': {'Dragon': 2.0, 'Acero': 0.5},
    'Oscuro': {'Lucha': 0.5, 'Psiquico': 2.0, 'Fantasma': 2.0, 'Oscuro': 0.5},
    'Acero': {'Fuego': 0.5, 'Agua': 0.5, 'Electrico': 0.5, 'Hielo': 2.0, 'Roca': 2.0, 'Acero': 0.5}
  };

  static double obtenerMultiplicador(String tipoAtaque, String tipoDefensor) {
    if (efectividad.containsKey(tipoAtaque)) {
      var mapaDefensor = efectividad[tipoAtaque];
      if (mapaDefensor != null && mapaDefensor.containsKey(tipoDefensor)) {
        return mapaDefensor[tipoDefensor]!;
      }
    }
    return 1.0;
  }
}

/// =========================
///        MODELO
/// =========================

enum Estado { sano, envenenado, quemado, congelado, paralizado }

class Pokemon {
  final String nombre;
  final int nivel;
  final String tipo;
  double vidaMax;
  double vida;
  double velocidadBase;
  double velocidad;
  Estado estado;
  List<Ataque> movimientos;

  static final Random _random = Random();

  Pokemon({
    required this.nombre,
    required this.nivel,
    required this.tipo,
    required this.movimientos,
  })  : vidaMax = (_random.nextDouble() * 50 + 50) * (nivel / 10),
        vida = 0,
        velocidadBase = (_random.nextDouble() * 30 + 10) * (nivel / 10),
        velocidad = 0,
        estado = Estado.sano {
    vida = vidaMax;
    velocidad = velocidadBase;
  }

  void aplicarEfectoDeEstado(CombateView view) {
    if (estado == Estado.quemado) {
      double danio = vidaMax / 8; // Daño residual
      vida -= danio;
      view.mostrarMensaje("$nombre sufre daño por quemadura (-${danio.toInt()} HP).");
    } else if (estado == Estado.envenenado) {
      double danio = vidaMax / 8;
      vida -= danio;
      view.mostrarMensaje("$nombre sufre daño por veneno (-${danio.toInt()} HP).");
    }
    if (vida < 0) vida = 0;
  }
  
  bool puedeMoverse(CombateView view) {
    if (estado == Estado.congelado) {
      view.mostrarMensaje("¡$nombre está congelado y no se puede mover!");
      return false;
    }
    if (estado == Estado.paralizado) {
      if (_random.nextInt(4) == 0) {
        view.mostrarMensaje("¡$nombre está paralizado y no se puede mover!");
        return false;
      }
      velocidad = velocidadBase * 0.5;
    } else {
      velocidad = velocidadBase;
    }
    return true;
  }
}

class Ataque {
  final String nombre;
  final String tipo;
  final int potencia;
  final Estado? efectoEstado;

  Ataque({
    required this.nombre,
    required this.tipo,
    required this.potencia,
    this.efectoEstado,
  });
}

abstract class Item {
  String nombre;
  Item(this.nombre);
  bool usar(Pokemon p, CombateView view);
}

class Pocion extends Item {
  Pocion() : super("Poción");
  @override
  bool usar(Pokemon p, CombateView view) {
    if (p.vida == p.vidaMax) {
      view.mostrarMensaje("La vida ya está al máximo.");
      return false;
    }
    p.vida += 20;
    if (p.vida > p.vidaMax) p.vida = p.vidaMax;
    view.mostrarMensaje("¡${p.nombre} recuperó 20 HP!");
    return true;
  }
}

class CuraTotal extends Item {
  CuraTotal() : super("Cura Total");
  @override
  bool usar(Pokemon p, CombateView view) {
    if (p.estado == Estado.sano) {
      view.mostrarMensaje("El pokemon no tiene problemas de estado.");
      return false;
    }
    p.estado = Estado.sano;
    p.velocidad = p.velocidadBase;
    view.mostrarMensaje("¡${p.nombre} se ha curado de su estado!");
    return true;
  }
}

/// =========================
///         VISTA
/// =========================

abstract class CombateView {
  void mostrarInformacionPokemon(Pokemon p);
  void mostrarMenuPrincipal();
  void mostrarMenuAtaques(Pokemon p);
  void mostrarMenuMochila(List<Item> items);
  void mostrarAtaque(Pokemon atacante, Pokemon defensor, Ataque ataque);
  void mostrarEfectividad(double multi);
  void mostrarDanio(double danio);
  void mostrarMensaje(String msg);
  String leerInput();
}

class ConsoleCombateView implements CombateView {
  @override
  void mostrarInformacionPokemon(Pokemon p) {
    String estadoStr = p.estado == Estado.sano ? "" : "[${p.estado.name.toUpperCase()}]";
    print('\n----------------------');
    print('${p.nombre} (Nv. ${p.nivel}) $estadoStr');
    print('HP: ${p.vida.toInt()} / ${p.vidaMax.toInt()}');
    print('Tipo: ${p.tipo}');
    print('----------------------\n');
  }

  @override
  void mostrarMenuPrincipal() {
    print("¿Qué debe hacer el Pokémon?");
    print("1. LUCHA");
    print("2. MOCHILA");
  }

  @override
  void mostrarMenuAtaques(Pokemon p) {
    print("Selecciona un ataque:");
    for (int i = 0; i < p.movimientos.length; i++) {
      print("${i + 1}. ${p.movimientos[i].nombre} (${p.movimientos[i].tipo})");
    }
  }

  @override
  void mostrarMenuMochila(List<Item> items) {
    print("Selecciona un objeto:");
    for (int i = 0; i < items.length; i++) {
      print("${i + 1}. ${items[i].nombre}");
    }
    print("0. Cancelar");
  }

  @override
  void mostrarAtaque(Pokemon atacante, Pokemon defensor, Ataque ataque) {
    print('${atacante.nombre} usó ${ataque.nombre}!');
  }

  @override
  void mostrarEfectividad(double multi) {
    if (multi > 1.0) print('¡Es súper efectivo!');
    if (multi < 1.0 && multi > 0.0) print('¡No es muy efectivo...');
    if (multi == 0.0) print('¡No afecta al Pokémon rival!');
  }

  @override
  void mostrarDanio(double danio) {
    print('Daño causado: ${danio.toInt()}');
  }

  @override
  void mostrarMensaje(String msg) {
    print(msg);
  }

  @override
  String leerInput() {
    stdout.write("> ");
    return stdin.readLineSync() ?? "";
  }
}

/// =========================
///      CONTROLADOR
/// =========================

class CombateController {
  final CombateView view;
  final Random _random = Random();
  List<Item> mochila = [Pocion(), Pocion(), CuraTotal()];

  CombateController(this.view);
  
  void iniciarCombate(Pokemon jugador, Pokemon rival) {
    view.mostrarMensaje('========== COMBATE INICIADO ==========');
    view.mostrarMensaje('¡Un ${rival.nombre} salvaje apareció!');
    view.mostrarMensaje('¡Ve ${jugador.nombre}!');

    bool combateActivo = true;

    while (combateActivo) {
      view.mostrarInformacionPokemon(rival);
      view.mostrarInformacionPokemon(jugador);
      
      bool turnoJugadorTerminado = false;
      bool jugadorAtaco = false;
      Ataque? ataqueJugador;

      while (!turnoJugadorTerminado) {
        view.mostrarMenuPrincipal();
        String opcion = view.leerInput();

        if (opcion == "1") {
          if (!jugador.puedeMoverse(view)) {
             turnoJugadorTerminado = true;
             jugadorAtaco = false; 
             break;
          }

          view.mostrarMenuAtaques(jugador);
          String opAtaque = view.leerInput();
          int? index = int.tryParse(opAtaque);
          
          if (index != null && index > 0 && index <= jugador.movimientos.length) {
            ataqueJugador = jugador.movimientos[index - 1];
            jugadorAtaco = true;
            turnoJugadorTerminado = true;
          } else {
            view.mostrarMensaje("Ataque inválido.");
          }

        } else if (opcion == "2") {
          view.mostrarMenuMochila(mochila);
          String opItem = view.leerInput();
          int? index = int.tryParse(opItem);

          if (index == 0) continue;

          if (index != null && index > 0 && index <= mochila.length) {
             Item item = mochila[index - 1];
             if (item.usar(jugador, view)) {
               mochila.removeAt(index - 1);
               turnoJugadorTerminado = true;
               jugadorAtaco = false;
             }
          }
        }
      }

      Ataque ataqueRival = rival.movimientos[_random.nextInt(rival.movimientos.length)];
      bool rivalPrimero = rival.velocidad > jugador.velocidad;
      
      if (!jugadorAtaco) {
        ejecutarAtaque(rival, jugador, ataqueRival);
      } else {
        if (rivalPrimero) {
          ejecutarTurnoDoble(rival, ataqueRival, jugador, ataqueJugador!);
        } else {
          ejecutarTurnoDoble(jugador, ataqueJugador!, rival, ataqueRival);
        }
      }

      jugador.aplicarEfectoDeEstado(view);
      rival.aplicarEfectoDeEstado(view);

      if (jugador.vida <= 0) {
        view.mostrarMensaje("¡${jugador.nombre} se ha desmayado! Perdiste.");
        combateActivo = false;
      } else if (rival.vida <= 0) {
        view.mostrarMensaje("¡${rival.nombre} ha sido derrotado! ¡Ganaste!");
        combateActivo = false;
      }
    }
  }

  void ejecutarTurnoDoble(Pokemon p1, Ataque a1, Pokemon p2, Ataque a2) {
    if (p1.vida > 0 && p1.puedeMoverse(view)) {
      ejecutarAtaque(p1, p2, a1);
    }
    if (p2.vida > 0 && p2.puedeMoverse(view)) {
      ejecutarAtaque(p2, p1, a2);
    }
  }

  void ejecutarAtaque(Pokemon atacante, Pokemon defensor, Ataque ataque) {
    view.mostrarAtaque(atacante, defensor, ataque);
    double multiplicador = TablaTipos.obtenerMultiplicador(ataque.tipo, defensor.tipo);
    view.mostrarEfectividad(multiplicador);
    double danio = ataque.potencia * multiplicador;
    danio = danio * ((_random.nextInt(16) + 85) / 100);
    if (atacante.tipo == ataque.tipo) danio *= 1.5;
    defensor.vida -= danio;
    view.mostrarDanio(danio);
    if (ataque.efectoEstado != null && defensor.estado == Estado.sano && defensor.vida > 0) {
      if (_random.nextInt(100) < 20) {
        defensor.estado = ataque.efectoEstado!;
        view.mostrarMensaje("¡${defensor.nombre} ha sido ${defensor.estado.name}!");
      }
    }
  }
}

/// =========================
///         MAIN
/// =========================

void main() {
  final view = ConsoleCombateView();
  final controller = CombateController(view);
  
  final placaje = Ataque(nombre: 'Placaje', tipo: 'Normal', potencia: 40);
  final lanzallamas = Ataque(nombre: 'Lanzallamas', tipo: 'Fuego', potencia: 90, efectoEstado: Estado.quemado);
  final hojaAfilada = Ataque(nombre: 'Hoja Afilada', tipo: 'Hierba', potencia: 55);
  final pistolaAgua = Ataque(nombre: 'Pistola Agua', tipo: 'Agua', potencia: 40);
  final rayo = Ataque(nombre: 'Rayo', tipo: 'Electrico', potencia: 90, efectoEstado: Estado.paralizado);
  final rayoHielo = Ataque(nombre: 'Rayo Hielo', tipo: 'Hielo', potencia: 90, efectoEstado: Estado.congelado);
  final terremoto = Ataque(nombre: 'Terremoto', tipo: 'Tierra', potencia: 100);
  final toxico = Ataque(nombre: 'Tóxico', tipo: 'Veneno', potencia: 10, efectoEstado: Estado.envenenado);
  final psiquico = Ataque(nombre: 'Psíquico', tipo: 'Psiquico', potencia: 90);
  final garraUmbria = Ataque(nombre: 'Garra Umbría', tipo: 'Fantasma', potencia: 70);

  final jugador = Pokemon(
    nombre: 'Charizard', 
    nivel: 50, 
    tipo: 'Fuego', 
    movimientos: [lanzallamas, placaje, terremoto, garraUmbria, pistolaAgua, rayo]
  );
  final rival = Pokemon(
    nombre: 'Venusaur', 
    nivel: 50, 
    tipo: 'Hierba', 
    movimientos: [hojaAfilada, toxico, placaje, rayoHielo, psiquico]
  );
  
  controller.iniciarCombate(jugador, rival);
}