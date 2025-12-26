import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appcoru/viewmodel/InformeEstacionesVm.dart';
import 'package:appcoru/model/Estacion.dart';
import 'package:appcoru/model/EstadoEstacion.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart'; // Núcleo de pdf
import 'package:pdf/widgets.dart'
    as pw; // Widgets de pdf (alias 'pw' para evitar conflictos con Flutter)
import 'package:printing/printing.dart'; // Para imprimir y compartir PDFs

// Pantalla de detalle que muestra:
// - Datos estáticos (nombre, dirección, capacidad)
// - Estado en tiempo real (bicis, e-bikes, anclajes)
// - Gráfico circular (PieChart)
// - Botón para exportar a PDF
class DetalleEstacionPage extends StatelessWidget {
  final Estacion estacion;

  const DetalleEstacionPage({super.key, required this.estacion});

  @override
  Widget build(BuildContext context) {
    // Obtiene el estado dinámico de la estación desde el ViewModel
    final vm = context.watch<InformeEstacionesVm>();
    final EstadoEstacion estado = vm.estadoDeEstacion(estacion.stationId);
    // Calcula valores para el gráfico
    final int bicisMecanicas = estado.numBikesAvailable;
    final int eBikes = estado.numEbikesAvailable;
    final int anclajesLibres = estado.numDocksAvailable;
    final int total = bicisMecanicas + eBikes + anclajesLibres;

    return Scaffold(
      appBar: AppBar(
        title: Text(estacion.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              _generarPdf(context, estacion, estado);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DATOS ESTÁTICOS
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
              // ESTADO EN TIEMPO REAL
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
                'Última actualización: ${_formatoFechaSinMilisegundos(estado.lastUpdated)}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              // GRÁFICO CIRCULAR (PieChart)
              const SizedBox(height: 24),
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
            ],
          ),
        ),
      ),
    );
  }

  // ========== FUNCIÓN DE EXPORTACIÓN A PDF ==========
  void _generarPdf(
    BuildContext context,
    Estacion estacion,
    EstadoEstacion estado,
  ) async {
    final pdf = pw.Document();

    String recomendacion;
    if (estado.numBikesAvailable > 0 || estado.numEbikesAvailable > 0) {
      recomendacion = "SÍ";
    } else if (estado.numDocksAvailable > 0) {
      recomendacion = "QUIZÁ";
    } else {
      recomendacion = "NO";
    }

    final fechaGeneracion = DateTime.now();

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Encabezado
            pw.Text(
              'Informe de Estación',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            // Datos estáticos
            pw.Text(
              'Estación:',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Nombre: ${estacion.name}',
              style: pw.TextStyle(fontSize: 16),
            ),
            pw.Text(
              'Dirección: ${estacion.address}',
              style: pw.TextStyle(fontSize: 16),
            ),
            pw.Text(
              'Capacidad total: ${estacion.capacity}',
              style: pw.TextStyle(fontSize: 16),
            ),
            pw.SizedBox(height: 16),
            // Estado actual
            pw.Text(
              'Estado actual:',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Bicis mecánicas disponibles: ${estado.numBikesAvailable}',
              style: pw.TextStyle(fontSize: 16),
            ),
            pw.Text(
              'E-bikes disponibles: ${estado.numEbikesAvailable}',
              style: pw.TextStyle(fontSize: 16),
            ),
            pw.Text(
              'Anclajes libres: ${estado.numDocksAvailable}',
              style: pw.TextStyle(fontSize: 16),
            ),
            pw.SizedBox(height: 16),
            //Me compensa bajar ahora con lógica simple
            pw.Text(
              '¿Me compensa bajar ahora?',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              recomendacion,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: _colorRecomendacion(recomendacion),
              ),
            ),
            pw.SizedBox(height: 16),

            pw.Text(
              'Fechas:',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Generado el: ${_formatoFecha(fechaGeneracion)}',
              style: pw.TextStyle(fontSize: 14),
            ),
            pw.Text(
              'Datos actualizados el: ${_formatoFecha(estado.lastUpdated)}',
              style: pw.TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
    // Muestra el PDF en pantalla o prepara para descargar
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Muestra el PDF en pantalla o prepara para descargar
  PdfColor _colorRecomendacion(String recomendacion) {
    switch (recomendacion) {
      case "SÍ":
        return PdfColors.green;
      case "QUIZÁ":
        return PdfColors.orange;
      case "NO":
        return PdfColors.red;
      default:
        return PdfColors.black;
    }
  }

  // Formatea fecha de forma legible
  String _formatoFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  String _formatoFechaSinMilisegundos(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
  }
}
