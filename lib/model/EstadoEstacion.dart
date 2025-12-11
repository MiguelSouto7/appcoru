class StationStatus {
  final String stationId;
  final int numBikesAvailable;
  final int numEbikesAvailable;
  final int numDocksAvailable;
  final DateTime lastUpdated;

  StationStatus({
    required this.stationId,
    required this.numBikesAvailable,
    required this.numEbikesAvailable,
    required this.numDocksAvailable,
    required this.lastUpdated,
  });

  factory StationStatus.fromJson(Map<String, dynamic> json) {
    return StationStatus(
      stationId: json['station_id'] as String,
      numBikesAvailable: (json['num_bikes_available'] ?? 0) as int,
      numEbikesAvailable: (json['num_ebikes_available'] ?? 0) as int,
      numDocksAvailable: (json['num_docks_available'] ?? 0) as int,
      // El endpoint tiene un timestamp global, pero aquí usamos DateTime.now() como marca local
      lastUpdated: DateTime.now(),
    );
  }
}