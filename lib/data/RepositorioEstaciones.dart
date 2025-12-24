import 'package:appcoru/model/Estacion.dart';
import 'package:appcoru/model/EstadoEstacion.dart';
import 'ApiEstaciones.dart';

// ====================================================================
// CAPA DE NEGOCIO: REPOSITORIO DE ESTACIONES
// ====================================================================
// Repositorio: capa intermedia entre la API y la lógica de la app.
// Convierte respuestas JSON en objetos Dart y centraliza el acceso a datos.
class RepositorioEstaciones {
  final ApiEstaciones api;

  // Constructor: asigna la API inyectada
  RepositorioEstaciones(this.api);

  // Carga datos estáticos (nombre, dirección, capacidad) y los convierte a objetos Estacion.
  Future<List<Estacion>> cargarEstaciones() async {
    final lista = await api.obtenerInformacion();
    return lista
        .map((e) => Estacion.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Carga datos dinámicos (bicis disponibles, e-bikes, anclajes) y los convierte a objetos EstadoEstacion.
  Future<List<EstadoEstacion>> cargarEstados() async {
    final lista = await api.obtenerEstado();
    print('Datos de estado recibidos: $lista'); // AÑADIR PARA DEPURACIÓN
    return lista
        .map((e) => EstadoEstacion.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
