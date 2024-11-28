//lib/components/category_card.dart

import 'package:flutter/material.dart';
import '../models/category.dart'; // Importa el modelo de categoría
import '../views/category_products_page.dart'; // Importa la vista de productos por categoría
import 'package:flutter_svg/flutter_svg.dart'; // Importa SvgPicture para manejar imágenes SVG

// Widget que muestra una tarjeta de categoría
class CategoryCard extends StatelessWidget {
  final Categoria categoria; // Categoría a mostrar

  CategoryCard({required this.categoria});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detecta toques en la tarjeta
      onTap: () {
        // Navega a la página de productos por categoría al tocar la tarjeta
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CategoryProductsPage(category: categoria.nombre),
          ),
        );
      },
      child: Card(
        color: Color.fromRGBO(247, 221, 190, 1), // Color de fondo de la tarjeta
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Muestra la imagen de la categoría
            SvgPicture.asset(
              categoria.imagenURL, // Usar la ruta local de la imagen
              width: 100, // Ancho de la imagen
              height: 100, // Alto de la imagen
              placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(30.0),
                child: const CircularProgressIndicator(), // Indicador de carga
              ),
            ),
            SizedBox(height: 20), // Espacio entre la imagen y el texto
            // Muestra el nombre de la categoría
            Text(
              categoria.nombre,
              style: TextStyle(
                fontSize: 24, // Tamaño del texto
                fontWeight: FontWeight.bold, // Texto en negrita
              ),
            ),
          ],
        ),
      ),
    );
  }
}
