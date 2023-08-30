import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/usuario.dart';
import 'home_page.dart';
import '../services/api_service.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateUsuarioPage extends StatefulWidget {
    final Usuario usuario;

  UpdateUsuarioPage({required this.usuario});

  @override
  _UpdateUsuarioPageState createState() => _UpdateUsuarioPageState();
}

class _UpdateUsuarioPageState extends State<UpdateUsuarioPage> {

  TextEditingController _nombreController = TextEditingController();
  TextEditingController _edadController = TextEditingController();
  TextEditingController _activoController = TextEditingController();
  TextEditingController _fechaController = TextEditingController();
  TextEditingController _correoController = TextEditingController();
    final ApiService _apiService = ApiService();


  void _navigateToHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(title: 'Examen App')),
    );
  }

    @override
  void initState() {
    super.initState();
    _nombreController.text = widget.usuario.nombre;
        _edadController.text = widget.usuario.edad.toString();
        _activoController.text = widget.usuario.activo.toString();

    _fechaController.text =
        '${widget.usuario.fecha.day.toString().padLeft(2, '0')}/${widget.usuario.fecha.month.toString().padLeft(2, '0')}/${widget.usuario.fecha.year}';
    _correoController.text = widget.usuario.correo.toString();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Editar Usuario'),
    ),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa un nombre válido';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _edadController,
              decoration: InputDecoration(
                labelText: 'Edad',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa una edad válida';
                }
                if (int.tryParse(value) == null) {
                  return 'Por favor, ingresa una edad válida';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _activoController,
              decoration: InputDecoration(
                labelText: 'Activo',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa un activo válido';
                }
                if (int.tryParse(value) == null) {
                  return 'Por favor, ingresa un número válido';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _fechaController,
              decoration: InputDecoration(
                labelText: 'Fecha',
              ),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa una fecha válida';
                }
                if (!_isValidDate(value)) {
                  return 'Por favor, ingresa una fecha con el formato dd/mm/yyyy';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _correoController,
              decoration: InputDecoration(
                labelText: 'Correo',
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa un correo válido';
                }
                if (int.tryParse(value) == null) {
                  return 'Por favor, ingresa un correo válido';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmar cambios'),
                      content: Text('¿Deseas guardar los cambios?'),
                      actions: [
                        TextButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.pop(context); // Cerrar el cuadro de diálogo
                            _navigateToHomePage(context);
                          },
                        ),
                        TextButton(
                          child: Text('Sí'),
                          onPressed: () {
                            Navigator.pop(context); // Cerrar el cuadro de diálogo
                            if (_validateForm()) {
                              final String nuevoNombre = _nombreController.text;
                              final String nuevaFecha = _fechaController.text;
                              final int nuevaEdad = int.parse(_edadController.text);
                              final int nuevoActivo = int.parse(_activoController.text);
                              final String nuevoCorreo = _correoController.text;

                              DateTime originalDate =
                                  DateFormat("dd-MM-yyyy").parse(nuevaFecha.replaceAll("/", "-"));
                              String formattedDateString = DateFormat("yyyy-MM-dd").format(originalDate);

                              Usuario usuarioActualizado = Usuario(
                                id: widget.usuario.id,
                                nombre: nuevoNombre,
                                edad: nuevaEdad,
                                activo: nuevoActivo,
                                fecha: DateTime.parse(formattedDateString),
                                correo: nuevoCorreo,
                              );

                              _apiService.modificarUsuario(context, usuarioActualizado);
                              _navigateToHomePage(context);
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    ),
  );
}


 
  bool _validateForm() {
    if (_nombreController.text.isEmpty || _nombreController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Por favor, ingresa un nombre válido'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
    if (!_containsOnlyLetters(_nombreController.text)) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Por favor, ingresa un nombre válido'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return false;
  }
    if (_edadController.text.isEmpty || int.tryParse(_edadController.text) == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Por favor, ingresa una edad válido'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }

    if (_activoController.text != '1' && _activoController.text != '0') {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('El activo solo puede ser 1 o 0'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return false;
  }

   
    if (_correoController.text.isEmpty || _correoController.text == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Por favor, ingresa un correo válido'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }

    return true;
  }
  bool _validatePlace(String value) {
    final placeRegex = RegExp(r'^[a-zA-Z\s]+$');
    return placeRegex.hasMatch(value);
  }
   bool _containsOnlyLetters(String value) {
       final lettersOnlyRegex = RegExp(r'^[a-zA-Z\s]+$');
    return lettersOnlyRegex.hasMatch(value);
  }
  
  bool _isValidDate(String value) {
    try {
      DateFormat('dd/MM/yyyy').parseStrict(value);
      return true;
    } catch (e) {
      return false;
    }
  }
}
