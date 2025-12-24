import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appcoru/viewmodel/InformeEstacionesVm.dart';
import 'package:appcoru/data/RepositorioEstaciones.dart';
import 'package:appcoru/data/ApiEstaciones.dart';
import 'package:appcoru/view/InformeEstacionPage.dart';

// - Crea la cadena de dependencias: ApiEstaciones → RepositorioEstaciones → InformeEstacionesVm
// - Inicia la carga automática de datos al abrir la app
// - Establece la pantalla principal (InformeEstacionesPage)
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Inyección de dependencias en cadena:
        // ApiEstaciones() → RepositorioEstaciones() → InformeEstacionesVm()
        ChangeNotifierProvider(
          create: (_) =>
              InformeEstacionesVm(RepositorioEstaciones(ApiEstaciones()))
                ..refrescar(), // carga inicial
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Informe Estaciones',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const InformeEstacionesPage(),
      ),
    );
  }
}
