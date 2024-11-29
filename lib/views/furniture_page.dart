//lib/views/furniture_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/furniture_controller.dart';
import '../models/furniture.dart';
import 'furniture_detail_page.dart';
import 'add_furniture_page.dart';
import '../components/product_image.dart'; // Importamos el componente de imagen

class FurniturePage extends StatelessWidget {
  final FurnitureController _controller = FurnitureController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Muebles'),
        backgroundColor:
            const Color.fromARGB(255, 123, 77, 49), // Color del AppBar
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.streamMuebles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay muebles disponibles'));
          }

          List<Mueble> muebles = snapshot.data!.docs
              .map((doc) => Mueble.fromSnapshot(doc))
              .toList();

          return ListView.builder(
            itemCount: muebles.length,
            itemBuilder: (context, index) {
              var mueble = muebles[index];
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(
                          255, 123, 77, 49), // Fondo del container
                      borderRadius:
                          BorderRadius.circular(10), // Bordes redondeados
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3), // Sombra gris
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2), // Desplazamiento de la sombra
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10), // Márgenes para separar los ítems
                    child: ListTile(
                      leading: ProductImage(
                        imagenURL: mueble.imagenURL,
                        size: 100,
                      ), // Usa el componente de imagen ajustado
                      title: Text(
                        mueble.nombre,
                        style: TextStyle(color: Colors.white),
                      ), // Nombre del producto
                      subtitle: Text(
                        'Stock: ${mueble.stock}',
                        style: TextStyle(color: Colors.white),
                      ), // Stock del producto
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MuebleDetailPage(mueble: mueble),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal:
                            15.0), // Ajusta el padding para el ancho del Divider
                    child: Divider(
                      height: 1,
                      color: Colors.grey, // Color del Divider
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFurniturePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
