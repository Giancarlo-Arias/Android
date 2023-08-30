import 'package:flutter/material.dart';
import 'update_usuario_page.dart';
import '../domain/usuario.dart';

class VerUsuarioesPage extends StatelessWidget {
  const VerUsuarioesPage({Key? key}) : super(key: key);
                    
  @override
  Widget build(BuildContext context) {
    final Usuario usuarioDetalles =
        ModalRoute.of(context)!.settings.arguments as Usuario;
    // Datos de ejemplo para las productoes
    List<Usuario> usuarios = [
      Usuario(
        id: 0,
        nombre: 'Usuario 1',
                edad: 20,
                        activo: 0,
        fecha: DateTime.now(),
        correo: 'usuario@gmail.com',
      ),
      // Agrega más objetos Producto si es necesario
    ];
 

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(8),
          color: Colors.yellow[100],
          child: Text(
            'Detalles del Usuario',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarioDetalles;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        usuario.nombre,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                             
             
                          Text(
                            'Edad: ${usuario.edad}',
                          ),
                                                    Text(
                            'Activo: ${usuario.activo}',
                          ),
                          Text(
                            'Fecha: ${usuario.fecha.day.toString().padLeft(2, '0')}/${usuario.fecha.month.toString().padLeft(2, '0')}/${usuario.fecha.year}',
                          ),
                       

                          Text(
                            'Correo: ${usuario.correo}',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdateUsuarioPage(usuario: usuarioDetalles),
                    ),
                  ).then((usuarioActualizada) {
                    if (usuarioActualizada != null) {
                      // Aquí puedes realizar acciones adicionales después de actualizar la excursión
                      // Por ejemplo, puedes actualizar la lista de productoes o mostrar un mensaje de éxito.
                      print('Usuario actualizado: ${usuarioActualizada.nombre}');
                    }
                  });
                },
                child: Text('Actualizar'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Regresar'),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

