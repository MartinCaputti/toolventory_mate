//lib/components/productos_necesarios_field.dart

import 'package:flutter/material.dart';

// Widget que muestra los campos de los productos necesarios para un mueble
class ProductosNecesariosField extends StatefulWidget {
  final Map<String, Map<String, dynamic>>
      productosNecesarios; // Mapa de productos necesarios
  final Map<String, String> productosExistentes; // Mapa de productos existentes
  final Function(Map<String, Map<String, dynamic>>)
      onChanged; // Callback que se llama cuando cambian los productos necesarios

  ProductosNecesariosField({
    required this.productosNecesarios,
    required this.productosExistentes,
    required this.onChanged,
  });

  @override
  _ProductosNecesariosFieldState createState() =>
      _ProductosNecesariosFieldState();
}

// Estado del widget ProductosNecesariosField
class _ProductosNecesariosFieldState extends State<ProductosNecesariosField> {
  // Método para agregar un nuevo campo de producto necesario
  void _addProductField() {
    String idProduct = DateTime.now().toString();
    widget.productosNecesarios[idProduct] = {'nombre': '', 'cantidad': 0};
    widget.onChanged(widget.productosNecesarios);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Ordenar los productos existentes alfabéticamente por nombre
    List<MapEntry<String, String>> sortedProducts =
        widget.productosExistentes.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value));

    return Column(
      children: [
        // Crear un campo para cada producto necesario
        for (var entry in widget.productosNecesarios.entries)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: entry.value['nombre'].isEmpty
                        ? null
                        : entry.value['nombre'],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          // Actualizar el producto necesario seleccionado
                          String selectedProductId = widget
                              .productosExistentes.entries
                              .firstWhere(
                                  (product) => product.value == newValue)
                              .key;
                          widget.productosNecesarios.remove(entry.key);
                          widget.productosNecesarios[selectedProductId] = {
                            'nombre': newValue,
                            'cantidad': entry.value['cantidad']
                          };
                          widget.onChanged(widget.productosNecesarios);
                        });
                      }
                    },
                    items: sortedProducts
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
                      if (!widget.productosExistentes.containsValue(value)) {
                        return 'El producto no existe';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 8.0),
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    initialValue: entry.value['cantidad'].toString(),
                    decoration: InputDecoration(labelText: 'Cantidad'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      entry.value['cantidad'] = int.tryParse(value) ?? 0;
                      widget.onChanged(widget.productosNecesarios);
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
      ],
    );
  }
}
