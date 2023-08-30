import 'package:flutter/material.dart';
import 'package:flutterexamen/view/home_page.dart';
import 'package:flutterexamen/view/create_usuario_page.dart';
import 'package:flutterexamen/view/ver_usuario_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Usuario App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 58, 183, 150),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Usuarios App'),
      routes: {
        '/Agregar': (context) => CreateUsuarioPage(),
        '/Ver': (context) => VerUsuarioesPage(),
      },
    );
  }
}
