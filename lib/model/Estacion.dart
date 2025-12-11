class Estacion {
  final String id;
  final String nombre;
  final String direccion;
  final double latitud;
  final double longitud;
  final int capacidad;

  Estacion({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.latitud,
    required this.longitud,
    required this.capacidad,
  });

  factory Estacion.desdeJson(Map<String, dynamic> json) {
    return Estacion(
      id: json['station_id'] as String,
      nombre: (json['name'] ?? '') as String,
      direccion: (json['address'] ?? '') as String,
      latitud: (json['lat'] as num).toDouble(),
      longitud: (json['lon'] as num).toDouble(),
      capacidad: (json['capacity'] ?? 0) as int,
    );
  }
}
