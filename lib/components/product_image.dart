// lib/components/product_image.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart'
    as http; //// para hacer una solicitud HEAD a la URL de la imagen y obtener su tipo de contenido.

class ProductImage extends StatelessWidget {
  final String imagenURL;

  ProductImage({required this.imagenURL});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Para manejar la carga y verificar el tipo de contenido de la imagen de manera asincrónica
      future: getImageType(imagenURL),
      //Realiza una solicitud HEAD a la URL de la imagen para obtener el tipo de contenido (por ejemplo, image/svg+xml, image/jpeg).Si la URL es válida, devuelve el tipo de contenido; si no, devuelve 'error'.

      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Muestra un indicador de carga mientras espera.
        } else if (snapshot.hasError) {
          return Icon(Icons.error,
              color: Colors.red); // Muestra un icono de error si hay un error.
        } else {
          final imageType = snapshot.data;
          if (imageType == 'svg+xml') {
            //// SvgPicture.network para imágenes SVG
            return SvgPicture.network(
              imagenURL,
              placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(30.0),
                child:
                    const CircularProgressIndicator(), // Muestra un indicador de carga mientras se carga la imagen.
              ),
              height: 100,
            );
          } else {
            return Image.network(
              //Image.network para otros formatos.
              imagenURL,
              fit: BoxFit.cover,
              height: 100,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return Icon(Icons.error,
                    color: Colors
                        .red); // Muestra un icono de error si falla la carga.
              },
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child; // Muestra la imagen cuando se carga.
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null, // Muestra un indicador de progreso mientras se carga la imagen.
                    ),
                  );
                }
              },
            );
          }
        }
      },
    );
  }

  // Función asincrónica para obtener el tipo de contenido de la imagen.
  Future<String> getImageType(String url) async {
    try {
      final response = await http.head(
          Uri.parse(url)); // Realiza una solicitud HEAD a la URL de la imagen.
      final contentType = response.headers[
          'content-type']; // Obtiene el tipo de contenido de la respuesta.
      return contentType?.split('/').last ??
          ''; // Devuelve el tipo de contenido o una cadena vacía si no se puede determinar.
    } catch (e) {
      return 'error'; // Devuelve 'error' si ocurre un error.
    }
  }
}
