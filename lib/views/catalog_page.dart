//lib/views/catalog_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/product_controller.dart';
import '../components/dismissible_product.dart';
import '../models/product.dart';
import 'edit_product_page.dart';
import 'add_product_page.dart';

class CatalogoPage extends StatelessWidget {
  final ProductController _controller = ProductController();
  final String? category; // Parámetro opcional para filtrar por categoría

  CatalogoPage({this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category != null
            ? 'Productos en $category'
            : 'Inventario de Productos'),
      ),
      body: StreamBuilder(
        stream: category != null
            ? FirebaseFirestore.instance
                .collection('productos')
                .where('categoria', isEqualTo: category)
                .snapshots()
            : FirebaseFirestore.instance.collection('productos').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var productos = snapshot.data!.docs.map((doc) {
            return Producto(
              id: doc.id,
              nombre: doc['nombre'],
              imagenURL: doc['imagenURL'],
              stock: (doc['stock'] is int)
                  ? doc['stock']
                  : int.parse(doc['stock']),
              descripcion: doc['descripcion'],
              categoria: doc['categoria'],
            );
          }).toList();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: productos.length,
            itemBuilder: (context, index) {
              var producto = productos[index];
              return GestureDetector(
                onLongPress: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProductPage(producto: producto),
                    ),
                  );
                },
                child: DismissibleProduct(
                  producto: producto,
                  controller: _controller,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: category == null
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductPage()),
                );
              },
              child: Icon(Icons.add),
            )
          : null, // Oculta el botón de añadir producto en la vista de categorías
    );
  }
}
