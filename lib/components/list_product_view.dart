//lib/components/list_product_view.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';
import '../views/edit_product_page.dart';

class ListProductView extends StatelessWidget {
  final List<Producto> productos;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback fetchMoreProducts;
  final ProductController controller;
  final Function(int) onDelete; // Callback para notificar al widget padre

  ListProductView({
    required this.productos,
    required this.isLoading,
    required this.hasMore,
    required this.fetchMoreProducts,
    required this.controller,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productos.length + 1,
      itemBuilder: (context, index) {
        if (index == productos.length) {
          if (isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (hasMore) {
            return ElevatedButton(
              onPressed: fetchMoreProducts,
              child: Text('Cargar más'),
            );
          } else {
            return SizedBox.shrink(); // No hay más productos
          }
        }
        var producto = productos[index];
        return ListTile(
          title: Text(producto.nombre),
          subtitle: Text('Stock: ${producto.stock}'),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProductPage(producto: producto),
              ),
            );
          },
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: producto.id != null
                ? () async {
                    await controller.deleteProduct(producto.id!);
                    onDelete(index); // Notificar al widget padre
                  }
                : null,
          ),
        );
      },
    );
  }
}
