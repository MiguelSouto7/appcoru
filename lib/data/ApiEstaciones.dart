import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiEstaciones {
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

  Future<List<dynamic>> obtenerEstado() async {
    final url = Uri.parse('$_base/station_status');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Error HTTP ${res.statusCode} en estado');
    }
    final decoded = jsonDecode(res.body);
    return decoded['data']['stations'] as List<dynamic>; // ← ¡Corregido!
  }
}
