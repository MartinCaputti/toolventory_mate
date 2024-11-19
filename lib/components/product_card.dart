//lib/components/product_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/product.dart';
import 'package:http/http.dart'
    as http; // para hacer una solicitud HEAD a la URL de la imagen y obtener su tipo de contenido.

class ProductCard extends StatelessWidget {
  final Producto producto;

  ProductCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: FutureBuilder(
                  // Para manejar la carga y verificar el tipo de contenido de la imagen de manera asincrónica
                  future: getImageType(producto.imagenURL),
                  //Realiza una solicitud HEAD a la URL de la imagen para obtener el tipo de contenido (por ejemplo, image/svg+xml, image/jpeg).Si la URL es válida, devuelve el tipo de contenido; si no, devuelve 'error'.

                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Muestra un indicador de carga mientras se obtiene el tipo de imagen
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // Muestra un icono de error si hay un problema al obtener el tipo de imagen
                      return Icon(Icons.error, color: Colors.red);
                    } else {
                      final imageType = snapshot.data;
                      if (imageType == 'svg+xml') {
                        // SvgPicture.network para imágenes SVG
                        return SvgPicture.network(
                          producto.imagenURL,
                          placeholderBuilder: (BuildContext context) =>
                              Container(
                            padding: const EdgeInsets.all(30.0),
                            child: const CircularProgressIndicator(),
                          ),
                          height: 100,
                        );
                      } else {
                        return Image.network(
                          //Image.network para otros formatos.
                          producto.imagenURL,
                          fit: BoxFit.cover,
                          height: 100,
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            // Muestra un icono de error si falla la carga de la imagen
                            return Icon(Icons.error, color: Colors.red);
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              // Muestra un indicador de carga mientras se carga la imagen
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            }
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ),
          Padding(
            // Nombre del producto
            padding: EdgeInsets.all(8.0),
            child: Text(
              producto.nombre,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            // Stock del producto
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Stock: ${producto.stock}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          // Descripción del producto
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              producto.descripcion ?? '',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

// Función asincrónica para obtener el tipo de contenido de la imagen
  Future<String> getImageType(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      final contentType = response.headers['content-type'];
      return contentType?.split('/').last ?? '';
    } catch (e) {
      return 'error';
    }
  }
}
