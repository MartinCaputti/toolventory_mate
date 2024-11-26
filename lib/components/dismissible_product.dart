//lib/components/dismissible_product.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';
import 'product_card.dart';

class DismissibleProduct extends StatelessWidget {
  final Producto producto;
  final ProductController controller;
  DismissibleProduct({required this.producto, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(producto
          .id!), // Usar aserciones no-nulas (!) para asegurarse de que id no sea null.
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
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
      onDismissed: (direction) async {
        await controller.deleteProduct(producto
            .id!); // Usar aserciones no-nulas (!) para asegurarse de que id no sea null.
        if (context.mounted) {
          // Verificar si el contexto aún está montado
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${producto.nombre} eliminado')),
          );
        }
      },
      child: ProductCard(
        producto: producto,
        controller: controller, // Pasar el controlador también
      ),
    );
  }
}
