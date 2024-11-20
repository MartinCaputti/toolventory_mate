//lib/views/category_products_page.dart

import 'package:flutter/material.dart';
import 'catalog_page.dart'; // Importar CatalogoPage

class CategoryProductsPage extends StatelessWidget {
  final String category;

  CategoryProductsPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return CatalogoPage(
        category:
            category); // Reutiliza CatalogoPage con el filtro de categoría
  }
}
