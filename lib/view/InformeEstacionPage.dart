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
                  child: Container(
                    height: 300,
                    color: Colors.grey[100],
                    child: BarChart(
                      BarChartData(
                        // Mostrar el eje Y para ver que los valores son 0
                        titlesData: FlTitlesData(
                          show: true, // ← Mostrar títulos del eje Y
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final estacion = top5[value.toInt()].key;
                                return Text(
                                  estacion.name.split(' ').first,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black54,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                        ), // ← Mostrar cuadrícula
                        borderData: FlBorderData(show: true),
                        barGroups: top5.asMap().entries.map((entry) {
                          final index = entry.key;
                          final estado = entry.value.value;

                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: estado.numEbikesAvailable.toDouble(),
                                color: Colors.blue[600],
                                width: 30,
                                // Mostrar el valor encima de la barra (aunque sea 0)
                                /*   rodStackItems: [
                                  BarChartRodStackItem(
                                    0,
                                    estado.numEbikesAvailable.toDouble()
                                    /* Text(
                                      '${estado.numEbikesAvailable}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),*/
                                  ),
                                ],*/
                              ),
                            ],
                          );
                        }).toList(),
                        groupsSpace: 16,
                        // Asegurar que el eje Y va desde 0
                        maxY: 10, // ← Ajusta según tus datos
                      ),
                    ),
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
}
