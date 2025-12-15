class Estacion {
  final String stationId;
  final String name;
  final String address;
  final double lat;
  final double lon;
  final int capacity;

  Estacion({
    required this.stationId,
    required this.name,
    required this.address,
    required this.lat,
    required this.lon,
    required this.capacity,
  });

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