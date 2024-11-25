import 'package:flutter/material.dart';
import 'package:toolventory_mate/components/necessary_products_field.dart';
import '../models/furniture.dart';
import '../controllers/furniture_controller.dart';
import 'necessary_products_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FurnitureForm extends StatefulWidget {
  final Mueble? mueble;
  final Function(Mueble) onSave;

  FurnitureForm({this.mueble, required this.onSave});

  @override
  _FurnitureFormState createState() => _FurnitureFormState();
}

class _FurnitureFormState extends State<FurnitureForm> {
  final _formKey = GlobalKey<FormState>();
  final FurnitureController _furnitureController = FurnitureController();

  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _imagenURLController;
  late TextEditingController _stockController;

  final Map<String, Map<String, dynamic>> _productosNecesarios = {};
  final Map<String, String> _productosExistentes = {};

  @override
  void initState() {
    super.initState();
    _nombreController =
        TextEditingController(text: widget.mueble?.nombre ?? '');
    _descripcionController =
        TextEditingController(text: widget.mueble?.descripcion ?? '');
    _imagenURLController =
        TextEditingController(text: widget.mueble?.imagenURL ?? '');
    _stockController =
        TextEditingController(text: widget.mueble?.stock.toString() ?? '0');

    if (widget.mueble != null) {
      _productosNecesarios.addAll(widget.mueble!.productosNecesarios);
    }
    _loadExistingProducts();
  }

  Future<void> _loadExistingProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('productos').get();
    setState(() {
      for (var doc in querySnapshot.docs) {
        _productosExistentes[doc.id] = doc['nombre'].toString();
      }
    });
  }

  Future<void> _saveMueble() async {
    if (_formKey.currentState!.validate()) {
      Mueble nuevoMueble = Mueble(
        id: widget.mueble?.id ?? '',
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        productosNecesarios: _productosNecesarios,
        imagenURL: _imagenURLController.text,
        stock: int.tryParse(_stockController.text) ?? 0,
      );

      widget.onSave(nuevoMueble);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
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
            decoration: InputDecoration(labelText: 'Stock'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese el stock';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          Text(
            'Productos Necesarios',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          ProductosNecesariosField(
            productosNecesarios: _productosNecesarios,
            productosExistentes: _productosExistentes,
            onChanged: (productosNecesarios) {
              setState(() {
                _productosNecesarios.addAll(productosNecesarios);
              });
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _saveMueble,
            child: Text(
                widget.mueble == null ? 'Agregar Mueble' : 'Guardar Mueble'),
          ),
        ],
      ),
    );
  }
}
