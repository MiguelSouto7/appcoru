import 'package:appcoru/model/Estacion.dart';
import 'package:appcoru/model/EstadoEstacion.dart';
import 'ApiEstaciones.dart';

class RepositorioEstaciones {
  final ApiEstaciones api;

  RepositorioEstaciones(this.api);

  Future<List<Estacion>> cargarEstaciones() async {
    final lista = await api.obtenerInformacion();
    return lista
        .map((e) => Estacion.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<EstadoEstacion>> cargarEstados() async {
    final lista = await api.obtenerEstado();
    return lista
        .map((e) => EstadoEstacion.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
