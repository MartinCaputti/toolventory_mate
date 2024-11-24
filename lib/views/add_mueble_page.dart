import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/furniture_controller.dart';
import '../models/furniture.dart';
import '../models/product.dart';

class AddMueblePage extends StatefulWidget {
  @override
  _AddMueblePageState createState() => _AddMueblePageState();
}

class _AddMueblePageState extends State<AddMueblePage> {
  final _formKey = GlobalKey<FormState>();
  final FurnitureController _furnitureController = FurnitureController();
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('productos');

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _imagenURLController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  final Map<String, Map<String, dynamic>> _productosNecesarios = {};
  final Map<String, String> _productosExistentes = {};

  @override
  void initState() {
    super.initState();
    _loadExistingProducts();
  }

  Future<void> _loadExistingProducts() async {
    QuerySnapshot querySnapshot = await _productCollection.get();
    setState(() {
      for (var doc in querySnapshot.docs) {
        _productosExistentes[doc.id] = doc['nombre'].toString();
      }
    });
  }

  void _addProductField() {
    String idProducto = DateTime.now().toString();
    _productosNecesarios[idProducto] = {'nombre': '', 'cantidad': 0};
    setState(() {});
  }

  Future<void> _saveMueble() async {
    if (_formKey.currentState!.validate()) {
      bool productosValidos = true;
      for (var entry in _productosNecesarios.entries) {
        if (!_productosExistentes.containsKey(entry.key)) {
          productosValidos = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Producto con ID "${entry.key}" no existe.'),
              backgroundColor: Colors.red,
            ),
          );
          break;
        }
      }

      if (productosValidos) {
        Mueble nuevoMueble = Mueble(
          id: '',
          nombre: _nombreController.text,
          descripcion: _descripcionController.text,
          productosNecesarios: _productosNecesarios,
          imagenURL: _imagenURLController.text,
          stock: int.tryParse(_stockController.text) ?? 0,
        );

        await _furnitureController.addMueble(nuevoMueble);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Mueble'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imagenURLController,
                decoration: InputDecoration(labelText: 'URL de Imagen'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una URL de imagen';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stock Inicial'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un stock inicial';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Productos Necesarios',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              for (var entry in _productosNecesarios.entries)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField<String>(
                          value: entry.value['nombre'].isEmpty
                              ? null
                              : entry.value['nombre'],
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                String selectedProductId = _productosExistentes
                                    .entries
                                    .firstWhere(
                                        (product) => product.value == newValue)
                                    .key;
                                _productosNecesarios.remove(entry.key);
                                _productosNecesarios[selectedProductId] = {
                                  'nombre': newValue,
                                  'cantidad': entry.value['cantidad']
                                };
                              });
                            }
                          },
                          items: _productosExistentes.entries
                              .map((product) => DropdownMenuItem<String>(
                                    value: product.value,
                                    child: Text(
                                      product.value,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          decoration:
                              InputDecoration(labelText: 'Nombre del Producto'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor seleccione un producto';
                            }
                            if (!_productosExistentes.containsValue(value)) {
                              return 'El producto no existe';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Flexible(
                        child: TextFormField(
                          initialValue: entry.value['cantidad'].toString(),
                          decoration: InputDecoration(labelText: 'Cantidad'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            entry.value['cantidad'] = int.tryParse(value) ?? 0;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese la cantidad';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addProductField,
                child: Text('Agregar Producto Necesario'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveMueble,
                child: Text('Guardar Mueble'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
