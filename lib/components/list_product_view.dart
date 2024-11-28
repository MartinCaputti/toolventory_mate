//lib/components/list_product_view.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';
import '../views/edit_product_page.dart';

// Widget que muestra una vista de lista de productos
class ListProductView extends StatelessWidget {
  final List<Producto> productos; // Lista de productos a mostrar
  final bool isLoading; // Indica si se están cargando más productos
  final bool hasMore; // Indica si hay más productos para cargar
  final VoidCallback fetchMoreProducts; // Callback para cargar más productos
  final ProductController
      controller; // Controlador para manejar acciones de productos
  final Function(int)
      onDelete; // Callback para notificar al widget padre cuando se elimina un producto

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
      itemCount: productos.length + 1, // Número de elementos en la lista
      itemBuilder: (context, index) {
        // Mostrar indicador de carga o botón para cargar más productos al final de la lista
        if (index == productos.length) {
          if (isLoading) {
            return Center(
                child: CircularProgressIndicator()); // Indicador de carga
          } else if (hasMore) {
            return ElevatedButton(
              onPressed:
                  fetchMoreProducts, // Callback para cargar más productos
              child: Text('Cargar más'),
            );
          } else {
            return SizedBox.shrink(); // No hay más productos
          }
        }

        var producto = productos[index]; // Producto actual
        return ListTile(
          title: Text(producto.nombre), // Nombre del producto
          subtitle: Text('Stock: ${producto.stock}'), // Stock del producto
          // Navegar a la página de edición al tocar un producto
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
                    await controller
                        .deleteProduct(producto.id!); // Eliminar el producto
                    onDelete(
                        index); // Notificar al widget padre que se eliminó un producto
                  }
                : null,
          ),
        );
      },
    );
  }
}
