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
        color: Color.fromRGBO(247, 221, 190, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              categoria.imagenURL, // Usar la ruta local de la imagen
              width: 100, // Aumentar el tamaño de la imagen
              height: 100,
              placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(30.0),
                child:
                    const CircularProgressIndicator(), // Muestra un indicador de carga
              ),
            ),
            SizedBox(
                height: 20), // Aumentar el espacio entre la imagen y el texto
            Text(
              categoria.nombre,
              style: TextStyle(
                fontSize: 24, // Aumentar el tamaño del texto
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
