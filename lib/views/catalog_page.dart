//lib/views/catalog_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/product_controller.dart';
import 'add_product_page.dart';
import 'edit_product_page.dart';
import '../models/product.dart';
import '../components/dismissible_product.dart';

class CatalogoPage extends StatelessWidget {
  final ProductController _controller = ProductController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario de Productos'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('productos').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var productos = snapshot.data!.docs.map((doc) {
            return Producto(
              id: doc.id,
              nombre: doc['nombre'],
              imagenURL: doc['imagenURL'],
              stock: (doc['stock']
                      is int) //// Esto era innecesario pero cuando agregue el update , sin este parseo lo toma como string y rompe la pantalla
                  ? doc['stock']
                  : int.parse(doc['stock']),
              descripcion: doc['descripcion'],
            );
          }).toList(); //hay que convertir los documentos de Firestore (QueryDocumentSnapshot) a objetos Producto antes de utilizarlos.

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
                ), // Uso mi DismissibleProduct para modularizar
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
