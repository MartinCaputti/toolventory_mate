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

/*CategoryPage muestra una lista de todas las categorías disponibles. 
Cuando elijo una categoría,  lleva a CategoryProductsPage, que muestra una lista de productos filtrados por la categoría seleccionada 
utilizando la lógica ya existente en CatalogoPage.*/