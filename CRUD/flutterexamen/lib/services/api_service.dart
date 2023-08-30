import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../domain/usuario.dart';
import 'package:intl/intl.dart';

class ApiService {
  Function()? onExcursionDeleted; // Define a callback function
  static const apiUrl = 'http://192.168.100.72:3000';

  Future<List<Usuario>> obtenerUsuarios() async {
  List<Usuario> usuariosData = [];
  try {
    var response = await http.get(Uri.parse("$apiUrl/listarUsuarios"));
    print(response.body); // Agrega esta línea para imprimir la respuesta completa
    var jsonResponse = jsonDecode(response.body);

    List<dynamic>? usuarioJsonList = jsonResponse['usuarios'];
    if (usuarioJsonList != null) {
      usuariosData = usuarioJsonList.map((usuarioJson) {
        return Usuario(
          id: usuarioJson['id'], 
          nombre: usuarioJson['nombre'],
          edad: usuarioJson['edad'],
          fecha: DateTime.parse(usuarioJson['fecha']),
          activo: usuarioJson['activo'],
          correo: usuarioJson['correo'],
        );
      }).toList();
    } else {
      print('El campo "usuarios" es nulo en la respuesta JSON');
    }
  } catch (e) {
    print(e);
  }
  return usuariosData;
}


Future<void> modificarUsuario(BuildContext context, Usuario e) async {
  try {
    String fechaFormateada = DateFormat('yyyy-MM-dd').format(e.fecha);

    var data = {
      'nombre': e.nombre,
      'edad': e.edad.toString(),
      'fecha': fechaFormateada,
      'activo': e.activo.toString(),
      'correo': e.correo,
    };

    var headers = {'Content-Type': 'application/json'};

    var res = await http.put(
      Uri.parse("$apiUrl/usuarios/${e.id}"), // Ajustar la URL para incluir el ID del usuario
      headers: headers,
      body: json.encode(data),
    );

    var resultado = jsonDecode(res.body);

    if (resultado['statusCode'] != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Actualizado con éxito'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar'),
        ),
      );
    }
  } catch (e) {
    print(e);
  }
}



 Future<void> insertarUsuario(
  BuildContext context,
  String nombre,
  int edad,
  DateTime fecha,
  bool activo,
  String correo,
) async {
  String fechaFormateada = DateFormat('yyyy-MM-dd').format(fecha);

  try {
    var data = {
      'nombre': nombre,
      'edad': edad.toString(),
      'fecha': fechaFormateada,
      'activo': activo.toString(), // Convertir el valor booleano a cadena
      'correo': correo,
    };

    var headers = {'Content-Type': 'application/json'};

    var res = await http.post(
      Uri.parse("$apiUrl/add-usuario"),
      headers: headers,
      body: json.encode(data),
    );

    var resultado = jsonDecode(res.body);

    if (resultado['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Agregado con éxito'),
        ),
      );
      // Limpiar los campos después de agregar
      nombre = '';
      edad = 0;
      activo = false;
      correo = '';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar'),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
      ),
    );
  }
}


  Future<void> eliminarUsuario(BuildContext context, int id) async {
  try {
    var response = await http.delete(Uri.parse("$apiUrl/usuarios/$id"));
    var resultado = jsonDecode(response.body);

    if (response.statusCode == 200 && resultado['message'] == 'Usuario eliminado correctamente') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resultado['message']),
        ),
      );

      if (onExcursionDeleted != null) {
        onExcursionDeleted!(); // Llama a la función de devolución de llamada
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar'),
        ),
      );
    }
  } catch (e) {
    print(e);
  }
}

}
