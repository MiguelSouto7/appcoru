import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appcoru/viewmodel/InformeEstacionesVm.dart';
import 'package:appcoru/model/Estacion.dart';
import 'package:appcoru/model/EstadoEstacion.dart';
import 'package:appcoru/view/DetalleEstacionesPage.dart';
import 'package:fl_chart/fl_chart.dart';

class InformeEstacionesPage extends StatelessWidget {
  const InformeEstacionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informe de Estaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<InformeEstacionesVm>().refrescar();
            },
          ),
        ],
      ),
      body: Consumer<InformeEstacionesVm>(
        builder: (context, vm, child) {
          if (vm.cargando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.error != null) {
            return Center(child: Text('Error: ${vm.error}'));
          }

          // Obtén el top 5 desde el ViewModel
          final top5 = vm.top5EstacionesConMasEbikes;
          //-> AÑADIR TEMPORALMENTE
          print('Top 5 estaciones: $top5');

          return Column(
            children: [
              // ========== GRÁFICO DE BARRAS: TOP 5 ESTACIONES POR E-BIKES ==========

              // Muestra el gráfico solo si hay datos
              if (top5.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título claro del gráfico
                      const Text(
                        'Top 5 estaciones por bicis totales disponibles',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Gráfico de barras
                      SizedBox(
                        height: 250,
                        child: BarChart(
                          BarChartData(
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index < top5.length) {
                                      final estacion = top5[index].key;
                                      return Text(
                                        estacion.name.split(' ').first,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black54,
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black54,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: true),
                            barGroups: top5.asMap().entries.map((entry) {
                              final index = entry.key;
                              final estacion = entry.value.key;
                              final estado = entry.value.value;
                              final totalBicis =
                                  estado.numBikesAvailable +
                                  estado.numEbikesAvailable;

                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: totalBicis.toDouble(),
                                    color: Colors.blue[600],
                                    width: 30,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              );
                            }).toList(),
                            groupsSpace: 20,
                            maxY: _calcularMaxY(top5), // Ajusta dinámicamente
                          ),
                        ),
                      ),

                      // Leyenda explicativa
                      const SizedBox(height: 8),
                      Text(
                        'Bicis totales = mecánicas + eléctricas',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              // ========== FIN DEL GRÁFICO ==========

              // --- MÉTRICAS GLOBALES ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Total estaciones: ${vm.totalEstaciones}'),
                    Text('Bicis disponibles: ${vm.totalBicisDisponibles}'),
                    Text('Ebicis disponibles: ${vm.totalEbicisDisponibles}'),
                    Text('Anclajes libres: ${vm.totalAnclajesLibres}'),
                  ],
                ),
              ),

              const Divider(),

              // --- LISTADO DE ESTACIONES ---
              Expanded(
                child: ListView.builder(
                  itemCount: vm.estaciones.length,
                  itemBuilder: (context, index) {
                    final estacion = vm.estaciones[index];
                    final estado = vm.estadoDeEstacion(estacion.stationId);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text(estacion.name),
                        subtitle: Text(estacion.address),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(' ${estado?.numBikesAvailable ?? 0}'),
                            Text(' ${estado?.numEbikesAvailable ?? 0}'),
                            Text(' ${estado?.numDocksAvailable ?? 0}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetalleEstacionPage(estacion: estacion),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ========== FUNCIÓN AUXILIAR PARA CALCULAR EL EJE Y MÁXIMO ==========
  static double _calcularMaxY(List<MapEntry<Estacion, EstadoEstacion>> top5) {
    int maxValor = 0;
    for (final entry in top5) {
      final total =
          entry.value.numBikesAvailable + entry.value.numEbikesAvailable;
      if (total > maxValor) maxValor = total;
    }
    // Aseguramos que el eje Y tenga al menos 10 unidades
    return (maxValor < 10) ? 10.0 : (maxValor + 5).toDouble();
  }
}
