import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appcoru/viewmodel/InformeEstacionesVm.dart';
import 'package:appcoru/model/Estacion.dart';
import 'package:appcoru/model/EstadoEstacion.dart';
import 'package:fl_chart/fl_chart.dart';

class DetalleEstacionPage extends StatelessWidget {
  final Estacion estacion;

  const DetalleEstacionPage({super.key, required this.estacion});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InformeEstacionesVm>();
    final EstadoEstacion estado = vm.estadoDeEstacion(estacion.stationId);

    // Calcular los valores para el gráfico
    final int bicisMecanicas = estado.numBikesAvailable;
    final int eBikes = estado.numEbikesAvailable;
    final int anclajesLibres = estado.numDocksAvailable;
    final int total = bicisMecanicas + eBikes + anclajesLibres;

    return Scaffold(
      appBar: AppBar(title: Text(estacion.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Información estática ---
              Text(
                'Dirección: ${estacion.address}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Coordenadas: (${estacion.lat}, ${estacion.lon})',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Capacidad total: ${estacion.capacity}',
                style: const TextStyle(fontSize: 16),
              ),
              const Divider(height: 32),

              // --- Estado actual ---
              Text(
                'Bicis mecánicas: $bicisMecanicas',
                style: const TextStyle(fontSize: 16),
              ),
              Text('E-bikes: $eBikes', style: const TextStyle(fontSize: 16)),
              Text(
                'Anclajes libres: $anclajesLibres',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Última actualización: ${estado.lastUpdated}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // ========== PIE CHART: DISTRIBUCIÓN DE LA ESTACIÓN ==========
              const Text(
                'Distribución actual:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (total > 0)
                SizedBox(
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        if (bicisMecanicas > 0)
                          PieChartSectionData(
                            value: bicisMecanicas.toDouble(),
                            color: Colors.green[600]!,
                            title: '$bicisMecanicas',
                            radius: 50,
                          ),
                        if (eBikes > 0)
                          PieChartSectionData(
                            value: eBikes.toDouble(),
                            color: Colors.blue[600]!,
                            title: '$eBikes',
                            radius: 50,
                          ),
                        if (anclajesLibres > 0)
                          PieChartSectionData(
                            value: anclajesLibres.toDouble(),
                            color: Colors.grey[400]!,
                            title: '$anclajesLibres',
                            radius: 50,
                          ),
                      ],
                      centerSpaceRadius: 40,
                    ),
                  ),
                )
              else
                Container(
                  height: 250,
                  color: Colors.grey[100],
                  child: const Center(
                    child: Text(
                      'Estación sin actividad',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              // ========== FIN DEL PIE CHART ==========
            ],
          ),
        ),
      ),
    );
  }
}
