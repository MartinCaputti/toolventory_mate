//lib/components/category_card.dart

import 'package:flutter/material.dart';
import '../models/category.dart';
import '../views/category_products_page.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importar SvgPicture

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
            SvgPicture.asset(
              categoria.imagenURL, // Usar la ruta local de la imagen
              width: 50, // Ajustar el tamaño según sea necesario
              height: 50,
              placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(30.0),
                child:
                    const CircularProgressIndicator(), // Muestra un indicador de carga
              ),
            ),
            SizedBox(height: 10),
            Text(categoria.nombre),
          ],
        ),
      ),
    );
  }
}
