//lib/components/dismissible_product.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';
import 'product_card.dart';

// Widget que muestra un producto con la posibilidad de ser descartado
class DismissibleProduct extends StatelessWidget {
  final Producto producto; // Producto a mostrar
  final ProductController
      controller; // Controlador para manejar acciones de productos

  DismissibleProduct({required this.producto, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(producto
          .id!), // Usar aserciones no-nulas (!) para asegurarse de que id no sea null
      direction: DismissDirection
          .endToStart, // Dirección para deslizar y descartar el producto
      background: Container(
        color: Colors.red, // Fondo rojo para indicar eliminación
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.delete, color: Colors.white), // Icono de eliminar
      ),
      // Método para confirmar si se debe descartar el producto
      confirmDismiss: (direction) async {
        bool result = false;
        result = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('¿Seguro que desea borrar?'),
              actions: [
                TextButton(
                  onPressed: () {
                    return Navigator.pop(context, false);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    return Navigator.pop(context, true);
                  },
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(color: Color.fromARGB(255, 76, 244, 54)),
                  ),
                ),
              ],
            );
          },
        );
        return result;
      },
      // Método que se llama cuando se descarta el producto
      onDismissed: (direction) async {
        await controller.deleteProduct(producto
            .id!); // Usar aserciones no-nulas (!) para asegurarse de que id no sea null
        if (context.mounted) {
          // Verificar si el contexto aún está montado
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${producto.nombre} eliminado')),
          );
        }
      },
      // Muestra la tarjeta del producto
      child: ProductCard(
        producto: producto,
        controller: controller, // Pasar el controlador también
      ),
    );
  }
}
