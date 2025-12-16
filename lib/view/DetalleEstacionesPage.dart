import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appcoru/viewmodel/InformeEstacionesVm.dart';
import 'package:appcoru/model/Estacion.dart';
import 'package:appcoru/model/EstadoEstacion.dart';

class DetalleEstacionPage extends StatelessWidget {
  final Estacion estacion;

  const DetalleEstacionPage({super.key, required this.estacion});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InformeEstacionesVm>();
    final EstadoEstacion estado = vm.estadoDeEstacion(estacion.stationId);

    return Scaffold(
      appBar: AppBar(
        title: Text(estacion.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dirección: ${estacion.address}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Coordenadas: (${estacion.lat}, ${estacion.lon})',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Capacidad total: ${estacion.capacity}',
                style: const TextStyle(fontSize: 16)),
            const Divider(height: 32),
            Text('Bicis disponibles: ${estado.numBikesAvailable}',
                style: const TextStyle(fontSize: 16)),
            Text('Ebicis disponibles: ${estado.numEbikesAvailable}',
                style: const TextStyle(fontSize: 16)),
            Text('Anclajes libres: ${estado.numDocksAvailable}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Última actualización: ${estado.lastUpdated}',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
