// Modelo que representa los datos de la estación de BiciCoruña.
class Estacion {
  final String stationId;
  final String name;
  final String address;
  final double lat;
  final double lon;
  final int capacity;

  // Constructor: crea una instancia con todos los campos
  Estacion({
    required this.stationId,
    required this.name,
    required this.address,
    required this.lat,
    required this.lon,
    required this.capacity,
  });

  // Factory crea una instancia de Estacion a partir de un Map desde JSON.
  // Se usa para convertir la respuesta de la API en un objeto Dart tipado.
  factory Estacion.fromJson(Map<String, dynamic> json) {
    return Estacion(
      stationId: json['station_id'] as String,
      name: (json['name'] ?? '') as String,
      address: (json['address'] ?? '') as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      capacity: (json['capacity'] ?? 0) as int,
    );
  }
}
