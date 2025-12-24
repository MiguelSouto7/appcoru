import 'dart:convert';
import 'package:http/http.dart' as http;

// ====================================================================
// CAPA DE DATOS: ACCESO A LA API EXTERNA
// ====================================================================
// Esta clase se encarga de comunicarse directamente con la API GBFS
// de BiciCoruña para obtener datos en tiempo real.
// ====================================================================
class ApiEstaciones {
  // URL base de la API GBFS de BiciCoruña
  static const String _base =
      'https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl'; // ← Sin espacios

  Future<List<dynamic>> obtenerInformacion() async {
    final url = Uri.parse('$_base/station_information');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Error HTTP ${res.statusCode} en información');
    }
    final decoded = jsonDecode(res.body);
    return decoded['data']['stations'] as List<dynamic>;
  }

  // Obtiene los datos ESTÁTICOS de todas las estaciones.
  // Retorna: Future<List<dynamic>> = promesa de una lista de mapas sin tipar
  Future<List<dynamic>> obtenerEstado() async {
    final url = Uri.parse('$_base/station_status');
    // Realiza una petición HTTP GET a la URL construida
    // 'await' espera a que la petición se complete antes de continuar
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Error HTTP ${res.statusCode} en estado');
    }
    // Convierte el cuerpo de la respuesta (texto JSON) en un objeto Dart
    // jsonDecode() transforma el string JSON en un Map<String, dynamic>
    final decoded = jsonDecode(res.body);
    // Extrae la lista de estaciones del objeto decodificado
    // Navega por la estructura: decoded['data']['stations']
    // Convierte explícitamente a List<dynamic> para evitar problemas de tipado
    return decoded['data']['stations'] as List<dynamic>; // ← ¡Corregido!
  }
}
