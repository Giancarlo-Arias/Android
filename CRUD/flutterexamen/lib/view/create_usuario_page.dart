import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_page.dart';

class CreateUsuarioPage extends StatefulWidget {
  const CreateUsuarioPage({Key? key}) : super(key: key);

  @override
  _CreateUsuarioPageState createState() => _CreateUsuarioPageState();
}

class _CreateUsuarioPageState extends State<CreateUsuarioPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  DateTime? _fecha;
  bool _activo = true;

  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  void _limpiarCampos() {
    _nombreController.clear();
    _edadController.clear();
    _correoController.clear();
    setState(() {
      _fecha = null;
      _activo = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Crear Usuario',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage(title: 'My App')), // Reemplaza MyHomePage con el nombre correcto de tu página de inicio
            );
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Color(0xFFE0FF85), // Cambia el color del card a E0FF85
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(labelText: 'Nombre'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa un nombre válido';
                        }
                        if (value.contains(RegExp(r'\d'))) {
                          return 'El nombre no debe contener números';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _edadController,
                      decoration: InputDecoration(labelText: 'Edad'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa una edad válido';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Por favor, ingresa un número válido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _fecha = selectedDate;
                          });
                        }
                      },
                      child: Text(
                        _fecha != null
                            ? 'Fecha: ${_fecha!.toString().substring(0, 10)}'
                            : 'Seleccionar fecha',
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _activo,
                          onChanged: (value) {
                            setState(() {
                              _activo = value!;
                            });
                          },
                        ),
                        Text('Activo'),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _correoController,
                      decoration: InputDecoration(labelText: 'Correo'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa un correo válido';
                        }
                        if (value.contains(RegExp(r'\d'))) {
                          return 'Por favor, ingresa un número válido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (_fecha == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Por favor, selecciona una fecha'),
                                ),
                              );
                            } else {
                              _apiService.insertarUsuario(
                                context,
                                _nombreController.text,
                                int.parse(_edadController.text),
                                _fecha!,
                                _activo,
                                _correoController.text,
                              );
                              _limpiarCampos();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Se creó un nuevo usuario'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                        child: Text('Agregar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
