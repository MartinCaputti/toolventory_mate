import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/furniture.dart';
import '../models/product.dart';
import '../controllers/furniture_controller.dart';
import '../controllers/product_controller.dart';

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
      DocumentSnapshot productDoc =
          await _productController.getProductById(productoId);
      Producto producto = Producto.fromSnapshot(productDoc);

      if (producto.stock < cantidadNecesaria) {
        stockSuficiente = false;
        mensajeError +=
            '${entry.value['nombre']} (falta ${cantidadNecesaria - producto.stock}), ';
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
    // Actualizar el stock del mueble
    if (mueble.stock > 0) {
      int nuevoStockMueble = mueble.stock - 1; // Restar 1 del stock de muebles
      await _furnitureController.updateMuebleStock(mueble.id, nuevoStockMueble);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mueble vendido correctamente.')),
      );
    } else {
      // Mostrar mensaje de error si no hay stock para vender
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay stock suficiente para vender.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mueble.nombre),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('muebles')
            .doc(mueble.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          Mueble muebleActualizado = Mueble.fromSnapshot(snapshot.data!);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(muebleActualizado.imagenURL),
                SizedBox(height: 8.0),
                Text(muebleActualizado.descripcion,
                    style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 8.0),
                Text('Stock: ${muebleActualizado.stock}',
                    style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 16.0),
                Text('Productos Necesarios:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                for (var entry in muebleActualizado.productosNecesarios.entries)
                  Text('${entry.value['nombre']}: ${entry.value['cantidad']}',
                      style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    await construirMueble(context);
                  },
                  child: Text('Construir Mueble'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    await venderMueble(context);
                  },
                  child: Text('Vender Mueble'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
