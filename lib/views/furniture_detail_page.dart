//lib/views/furniture_detail_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/furniture.dart';
import '../models/product.dart';
import '../controllers/furniture_controller.dart';
import '../controllers/product_controller.dart';
import 'edit_furniture_page.dart';

class MuebleDetailPage extends StatelessWidget {
  final Mueble mueble;
  final FurnitureController _furnitureController = FurnitureController();
  final ProductController _productController = ProductController();

  MuebleDetailPage({required this.mueble});

  Future<void> construirMueble(BuildContext context) async {
    bool stockSuficiente = true;
    String mensajeError = 'Faltan los siguientes productos: ';

    // Verificar el stock de los productos necesarios
    for (var entry in mueble.productosNecesarios.entries) {
      String productoId = entry.key;
      int cantidadNecesaria = entry.value['cantidad'];
      Producto producto = await _productController.getProductById(productoId);

      if (producto == null) {
        stockSuficiente = false;
        mensajeError += 'Producto con ID $productoId no existe, ';
      } else {
        if (producto.stock < cantidadNecesaria) {
          stockSuficiente = false;
          mensajeError +=
              '${producto.nombre} (falta ${cantidadNecesaria - producto.stock}), ';
        }
      }
    }

    if (stockSuficiente) {
      // Actualizar el stock de los productos necesarios
      for (var entry in mueble.productosNecesarios.entries) {
        String productoId = entry.key;
        int cantidadNecesaria = entry.value['cantidad'];
        await _productController.updateStockForFurniture(
            productoId, cantidadNecesaria);
      }

      // Actualizar el stock del mueble
      int nuevoStockMueble = mueble.stock + 1; // Sumar 1 al stock de muebles
      await _furnitureController.updateMuebleStock(mueble.id, nuevoStockMueble);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mueble construido correctamente.')),
      );
    } else {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensajeError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> venderMueble(BuildContext context) async {
    if (mueble.stock > 0) {
      int nuevoStockMueble = mueble.stock - 1; // Restar 1 del stock de muebles
      await _furnitureController.updateMuebleStock(mueble.id, nuevoStockMueble);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mueble vendido correctamente.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay stock suficiente para vender.')),
      );
    }
  }

  Future<void> borrarMueble(BuildContext context) async {
    bool? confirmar = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('¿Seguro que desea borrar este mueble?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Confirmar', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await _furnitureController.deleteMueble(mueble.id);
      Navigator.pop(
          context); // Regresar a la página anterior después de eliminar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mueble eliminado correctamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mueble.nombre),
        backgroundColor:
            const Color.fromARGB(255, 123, 77, 49), // Color del AppBar
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Color.fromRGBO(217, 150, 67, 1),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditFurniturePage(mueble: mueble),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Color.fromRGBO(255, 151, 151, 1)),
            onPressed: () async {
              await borrarMueble(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFF2D0A7), // Color liso claro para el fondo
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('muebles')
              .doc(mueble.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.data!.exists) {
              return Center(child: Text('El mueble no existe.'));
            }

            Mueble muebleActualizado = Mueble.fromSnapshot(snapshot.data!);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(muebleActualizado.imagenURL),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            muebleActualizado.nombre,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            muebleActualizado.descripcion,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Stock: ${muebleActualizado.stock}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Productos Necesarios:',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var entry
                              in muebleActualizado.productosNecesarios.entries)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                '${entry.value['nombre']}: ${entry.value['cantidad']}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      await construirMueble(context);
                    },
                    child: Text(
                      'Construir Mueble',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity,
                          50), // Botón ancho completo y mayor altura
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      await venderMueble(context);
                    },
                    child: Text(
                      'Vender Mueble',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(249, 52, 73, 40),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
