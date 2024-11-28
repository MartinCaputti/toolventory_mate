//lib/components/grid_product_view.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import 'dismissible_product.dart';
import '../controllers/product_controller.dart';
import '../views/edit_product_page.dart';

// Widget que muestra una vista de cuadrícula de productos
class GridProductView extends StatelessWidget {
  final List<Producto> productos; // Lista de productos a mostrar
  final bool isLoading; // Indica si se están cargando más productos
  final bool hasMore; // Indica si hay más productos para cargar
  final VoidCallback fetchMoreProducts; // Callback para cargar más productos
  final ProductController
      controller; // Controlador para manejar acciones de productos

  GridProductView({
    required this.productos,
    required this.isLoading,
    required this.hasMore,
    required this.fetchMoreProducts,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // Configuración del diseño de la cuadrícula
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Número de columnas
        childAspectRatio: 2 / 3, // Relación de aspecto de los elementos
        crossAxisSpacing: 10, // Espaciado horizontal entre elementos
        mainAxisSpacing: 10, // Espaciado vertical entre elementos
      ),
      itemCount: productos.length + 1, // Número de elementos en la cuadrícula
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
        return GestureDetector(
          // Navegar a la página de edición al mantener presionado un producto
          onLongPress: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProductPage(producto: producto),
              ),
            );
          },
          // Widget que muestra el producto con la posibilidad de ser descartado
          child: DismissibleProduct(
            producto: producto,
            controller: controller,
          ),
        );
      },
    );
  }
}
