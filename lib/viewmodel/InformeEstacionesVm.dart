import 'package:flutter/foundation.dart';
import 'package:appcoru/data/RepositorioEstaciones.dart';
import 'package:appcoru/model/Estacion.dart';
import 'package:appcoru/model/EstadoEstacion.dart';

// ViewModel:
// - Coordina la carga de datos desde el repositorio
// - Calcula métricas globales
// - Proporciona métodos para acceder al estado de estaciones individuales
// - Notifica a la UI cuando hay cambios (ChangeNotifier)
class InformeEstacionesVm extends ChangeNotifier {
  final RepositorioEstaciones repositorio;

  // Constructor con inyección de dependencias
  InformeEstacionesVm(this.repositorio);

  // Estado de carga y errores
  bool cargando = false;
  String? error;

  // Listas de datos: estaciones -> estáticos y estados -> dinámicos
  List<Estacion> estaciones = <Estacion>[];
  List<EstadoEstacion> estados = <EstadoEstacion>[];

  // --- MÉTRICAS GLOBALES -> calculadas en tiempo real ---
  int get totalEstaciones => estaciones.length;
  int get totalBicisDisponibles =>
      estados.fold(0, (suma, e) => suma + e.numBikesAvailable);
  int get totalEbicisDisponibles =>
      estados.fold(0, (suma, e) => suma + e.numEbikesAvailable);
  int get totalAnclajesLibres =>
      estados.fold(0, (suma, e) => suma + e.numDocksAvailable);

  // --- MÉTODO DE CARGA DE LOS DATOS DE ESTACIONES ---
  Future<void> cargarEstaciones() async {
    try {
      estaciones = (await repositorio.cargarEstaciones()).cast<Estacion>();
    } catch (e) {
      error = 'Error al cargar estaciones: $e';
      estaciones = <Estacion>[];
    }
    notifyListeners();
  }

  // --- MÉTODO CARGA DE LOS DATOS DINÁMICOS (estados) -> en tiempo real ---
  Future<void> cargarEstados() async {
    try {
      estados = await repositorio.cargarEstados();
    } catch (e) {
      error = 'Error al cargar estados: $e';
      estados = <EstadoEstacion>[];
    }
    notifyListeners();
  }

  // --- MÉTODO GLOBAL (actualiza toda la info)---
  Future<void> refrescar() async {
    cargando = true;
    error = null;
    notifyListeners();

    // Carga estaciones y estados de datos en paralelo
    await Future.wait([cargarEstaciones(), cargarEstados()]);

    // Pintar para depuración(PRUEBA)
    print('Estaciones: ${estaciones.length}');
    print('Estados: ${estados.length}');

    cargando = false;
    notifyListeners();
  }

  // --- ESTADO INDIVIDUAL ---
  // Busca el estado de una estación por su ID
  // Si no lo encuentra, devuelve un estado vacío para evitar errores
  EstadoEstacion estadoDeEstacion(String id) {
    return estados.firstWhere(
      (e) => e.stationId == id,
      orElse: () => EstadoEstacion(
        stationId: id,
        numBikesAvailable: 0,
        numEbikesAvailable: 0,
        numDocksAvailable: 0,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  // Método que devuelve las 5 estaciones con más e-bikes disponibles.
  List<MapEntry<Estacion, EstadoEstacion>> get top5EstacionesConMasEbikes {
    final combinadas = <MapEntry<Estacion, EstadoEstacion>>[];

    // Empareja cada estación con su estado actual
    for (final estacion in estaciones) {
      final estado = estados.firstWhere(
        (e) => e.stationId == estacion.stationId,
        orElse: () => EstadoEstacion(
          stationId: estacion.stationId,
          numBikesAvailable: 0,
          numEbikesAvailable: 0,
          numDocksAvailable: 0,
          lastUpdated: DateTime.now(),
        ),
      );
      combinadas.add(MapEntry(estacion, estado));
    }

    // Ordenar por bicis totales (mecánicas + eléctricas)
    combinadas.sort((a, b) {
      final totalA = a.value.numBikesAvailable + a.value.numEbikesAvailable;
      final totalB = b.value.numBikesAvailable + b.value.numEbikesAvailable;
      return totalB.compareTo(totalA);
    });

    // Devuelvelas 5 primeras
    return combinadas.take(5).toList();
  }
}
