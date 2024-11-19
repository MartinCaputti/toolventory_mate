//lib/views/catalog_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CatalogoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario de Productos'), // Título en  AppBar
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('productos')
            .snapshots(), // Escucha cambios en la colección 'productos'
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            // Si no tengo nada en la base o mientras se espero los datos de Firestore
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
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Alineación del contenido al inicio
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(
                            8.0), // Espaciado interno en el contenedor
                        child: SvgPicture.network(
                          producto['imagenURL'],
                          placeholderBuilder: (BuildContext context) =>
                              Container(
                            padding: const EdgeInsets.all(30.0),
                            child: const CircularProgressIndicator(),
                          ),
                          height: 100,
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
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para añadir nuevos productos
        },
        child: Icon(Icons.add), // Icono del botón flotante
      ),
    );
  }
}
