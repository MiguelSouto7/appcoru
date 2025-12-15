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

    await Future.wait([
      cargarEstaciones(),
      cargarEstados(),
    ]);

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
}
