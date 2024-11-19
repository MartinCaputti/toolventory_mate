//lib/views/catalog_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/product_controller.dart';
import 'add_product_page.dart';
import 'edit_product_page.dart';
import '../models/product.dart';

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
                      is int) // Esto era innecesario pero cuando agregue el update , sin este parseo lo toma como string y rompe la pantalla
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
                child: Dismissible(
                  key: Key(producto
                      .id!), //Usar aserciones no-nulas (!) para asegurarse de que id no sea null.
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    bool result = false;
                    result = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('¿Seguro que desea borrar?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                return Navigator.pop(context, false);
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                return Navigator.pop(context, true);
                              },
                              child: const Text(
                                'Confirmar',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 76, 244, 54)),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    return result;
                  },
                  onDismissed: (direction) async {
                    await _controller.deleteProduct(producto
                        .id!); // Usar aserciones no-nulas (!) para asegurarse de que id no sea null.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${producto.nombre} eliminado')),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: SvgPicture.network(
                                producto.imagenURL,
                                placeholderBuilder: (BuildContext context) =>
                                    Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child: const CircularProgressIndicator(),
                                ),
                                height: 100,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            producto.nombre,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Stock: ${producto.stock}',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            producto.descripcion ?? '',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
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
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
