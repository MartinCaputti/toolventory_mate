//lib/components/category_card.dart

import 'package:flutter/material.dart';
import '../models/category.dart';
import '../views/category_products_page.dart';
import 'product_image.dart'; // Importar el widget ProductImage

class CategoryCard extends StatelessWidget {
  final Categoria categoria;

  CategoryCard({required this.categoria});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CategoryProductsPage(category: categoria.nombre),
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProductImage(
                imagenURL:
                    categoria.imagenURL), // Utiliza el widget ProductImage
            SizedBox(height: 10),
            Text(categoria.nombre),
          ],
        ),
      ),
    );
  }
}
