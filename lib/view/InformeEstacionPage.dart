import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appcoru/viewmodel/InformeEstacionesVm.dart';
import 'package:appcoru/model/Estacion.dart';
import 'package:appcoru/model/EstadoEstacion.dart';
import 'package:appcoru/view/DetalleEstacionesPage.dart';

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

          return Column(
            children: [
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
                          horizontal: 12, vertical: 6),
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
                              builder: (context) => DetalleEstacionPage(estacion: estacion
                                
                              ),
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
