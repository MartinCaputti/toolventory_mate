//lib/views/catalog_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/product_controller.dart';
import 'add_product_page.dart';

class CatalogoPage extends StatelessWidget {
  final ProductController _controller = ProductController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario de Productos'), // Título en AppBar
      ),
      body: StreamBuilder(
        //Escucha los cambios en tiempo real en la colección productos de Firestore
        stream: FirebaseFirestore.instance
            .collection('productos')
            .snapshots(), // Escucha cambios en la colección 'productos'
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            // Si no tengo nada en la base o mientras se esperan los datos de Firestore
            return Center(
                child:
                    CircularProgressIndicator()); // Muestra un indicador de carga
          }
          var productos =
              snapshot.data!.docs; // Obtiene los documentos de productos
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Número de columnas en el GridView
              childAspectRatio: 2 / 3, // Proporción de los elementos en el grid
              crossAxisSpacing: 10, // Espaciado horizontal entre los elementos
              mainAxisSpacing: 10, // Espaciado vertical entre los elementos
            ),
            itemCount: productos.length, // Número de elementos en el GridView
            itemBuilder: (context, index) {
              var producto = productos[index];
              return Dismissible(
                key: Key(producto.id), // Identificador único para cada producto
                direction:
                    DismissDirection.endToStart, // Dirección de deslizamiento
                background: Container(
                  color: Colors.red, // Fondo rojo para indicar eliminación
                  alignment: Alignment.centerRight, // Alineación a la derecha
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.0), // Espaciado interno
                  child: Icon(Icons.delete,
                      color: Colors.white), // Icono de eliminación en blanco
                ),
                onDismissed: (direction) async {
                  await _controller.deleteProduct(
                      producto.id); // Eliminar producto al deslizar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${producto['nombre']} eliminado')),
                  ); // Mostrar mensaje de confirmación
                },
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Alineación del contenido al inicio
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(
                              8.0), // Espaciado interno en el contenedor
                          child: Center(
                            // Centrar la imagen SVG
                            child: SvgPicture.network(
                              producto['imagenURL'],
                              placeholderBuilder: (BuildContext context) =>
                                  Container(
                                padding: const EdgeInsets.all(30.0),
                                child: const CircularProgressIndicator(),
                              ),
                              height: 100, // Altura de la imagen
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(8.0), // Espaciado interno del texto
                        child: Text(
                          producto['nombre'],
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight
                                  .bold), // Estilo del texto del nombre del producto
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0), // Espaciado horizontal del texto
                        child: Text(
                          'Stock: ${producto['stock']}',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey), // Estilo del texto del stock
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0), // Espaciado interno del texto
                        child: Text(
                          producto['descripcion'] ??
                              '', // Descripción del producto (si existe)
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[
                                  600]), // Estilo del texto de la descripción
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddProductPage()), // Navega a la página de añadir productos
          );
        },
        child: Icon(Icons.add), // Icono del botón flotante
      ),
    );
  }
}
