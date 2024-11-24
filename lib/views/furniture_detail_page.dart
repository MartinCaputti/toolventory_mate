import 'package:flutter/material.dart';
import '../models/furniture.dart';
import '../controllers/furniture_controller.dart';
import '../controllers/product_controller.dart';

class MuebleDetailPage extends StatelessWidget {
  final Mueble mueble;
  final FurnitureController _furnitureController = FurnitureController();
  final ProductController _productController = ProductController();

  MuebleDetailPage({required this.mueble});

  Future<void> construirMueble(BuildContext context) async {
    for (var entry in mueble.productosNecesarios.entries) {
      String productoId = entry.key;
      int cantidadNecesaria = entry.value['cantidad'];
      // Usar el nuevo método para disminuir el stock del producto
      await _productController.updateStockForFurniture(
          productoId, cantidadNecesaria);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mueble construido correctamente.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mueble.nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(mueble.imagenURL),
            SizedBox(height: 8.0),
            Text(mueble.descripcion, style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 8.0),
            Text('Stock: ${mueble.stock}', style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 16.0),
            Text('Productos Necesarios:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            for (var entry in mueble.productosNecesarios.entries)
              Text('${entry.value['nombre']}: ${entry.value['cantidad']}',
                  style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await construirMueble(context);
              },
              child: Text('Construir Mueble'),
            ),
          ],
        ),
      ),
    );
  }
}
