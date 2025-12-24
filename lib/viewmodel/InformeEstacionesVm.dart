import 'package:flutter/foundation.dart';
import 'package:appcoru/data/RepositorioEstaciones.dart';
import 'package:appcoru/model/Estacion.dart';
import 'package:appcoru/model/EstadoEstacion.dart';

class InformeEstacionesVm extends ChangeNotifier {
  final RepositorioEstaciones repositorio;

  InformeEstacionesVm(this.repositorio);

  bool cargando = false;
  String? error;

  List<Estacion> estaciones = <Estacion>[];
  List<EstadoEstacion> estados = <EstadoEstacion>[];

  // --- MÉTRICAS ---
  int get totalEstaciones => estaciones.length;
  int get totalBicisDisponibles =>
      estados.fold(0, (suma, e) => suma + e.numBikesAvailable);
  int get totalEbicisDisponibles =>
      estados.fold(0, (suma, e) => suma + e.numEbikesAvailable);
  int get totalAnclajesLibres =>
      estados.fold(0, (suma, e) => suma + e.numDocksAvailable);

  // --- MÉTODOS DE CARGA ---
  Future<void> cargarEstaciones() async {
    try {
      estaciones = (await repositorio.cargarEstaciones()).cast<Estacion>();
    } catch (e) {
      error = 'Error al cargar estaciones: $e';
      estaciones = <Estacion>[];
    }
    notifyListeners();
  }

  Future<void> cargarEstados() async {
    try {
      estados = await repositorio.cargarEstados();
    } catch (e) {
      error = 'Error al cargar estados: $e';
      estados = <EstadoEstacion>[];
    }
    notifyListeners();
  }

  // --- MÉTODO GLOBAL ---
  Future<void> refrescar() async {
    cargando = true;
    error = null;
    notifyListeners();

    await Future.wait([cargarEstaciones(), cargarEstados()]);

    // Pintar para depuración
    print('Estaciones: ${estaciones.length}');
    print('Estados: ${estados.length}');

    cargando = false;
    notifyListeners();
  }

  // --- ESTADO INDIVIDUAL ---
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

    return combinadas.take(5).toList();
  }
}
