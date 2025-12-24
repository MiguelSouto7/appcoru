import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appcoru/viewmodel/InformeEstacionesVm.dart';
import 'package:appcoru/data/RepositorioEstaciones.dart';
import 'package:appcoru/data/ApiEstaciones.dart';
import 'package:appcoru/view/InformeEstacionPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
