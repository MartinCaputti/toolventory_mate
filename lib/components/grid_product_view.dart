//lib/components/grid_product_view.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import 'dismissible_product.dart';
import '../controllers/product_controller.dart';
import '../views/edit_product_page.dart';

class GridProductView extends StatelessWidget {
  final List<Producto> productos;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback fetchMoreProducts;
  final ProductController controller;

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
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
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
        return GestureDetector(
          onLongPress: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProductPage(producto: producto),
              ),
            );
          },
          child: DismissibleProduct(
            producto: producto,
            controller: controller,
          ),
        );
      },
    );
  }
}
