//lib/views/catalog_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                        child: SingleChildScrollView(
                          // Permite desplazamiento si el contenido es demasiado grande
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Alineación del contenido de la columna al inicio
                            children: [
                              Text(
                                producto['nombre'],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight
                                        .bold), // Estilo del texto del nombre del producto
                              ),
                              SizedBox(
                                  height:
                                      4.0), // Espacio entre el nombre y el stock
                              Text(
                                'Stock: ${producto['stock']}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors
                                        .grey), // Estilo del texto del stock
                              ),
                              SizedBox(
                                  height:
                                      4.0), // Espacio entre el stock y la descripción
                              Text(
                                producto['descripcion'] ??
                                    '', // Descripción del producto (si existe)
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[
                                        600]), // Estilo del texto de la descripción
                              ),
                            ],
                          ),
                        ),
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
