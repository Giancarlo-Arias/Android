import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../domain/usuario.dart';
import '../services/api_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Usuario> usuariosData = [];
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    apiService.obtenerUsuarios().then((data) {
      setState(() {
        usuariosData = data;
        print(usuariosData.length);
      });
    });
  }

  void refreshView() {
    setState(() {
      usuariosData = [];
    });
    apiService.obtenerUsuarios().then((data) {
      setState(() {
        usuariosData = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: usuariosData.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                // Handle onTap event
              },
              child: ListTile(
                title: Text(usuariosData[index].nombre),
subtitle: Text('\n' + usuariosData[index].edad.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/Ver',
                          arguments: usuariosData[index],
                        );
                      },
                      child: Icon(CupertinoIcons.eye),
                    ),
                    SizedBox(width: 16),
                  GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar este usuario?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop();
                apiService.eliminarUsuario(
                  context,
                  usuariosData[index].id,
                );
                refreshView();
              },
            ),
          ],
        );
      },
    );
  },
  child: Icon(CupertinoIcons.delete_simple),
)
,
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/Agregar');
        },
        tooltip: 'Agregar',
        child: const Icon(Icons.add),
      ),
    );
  }
}
