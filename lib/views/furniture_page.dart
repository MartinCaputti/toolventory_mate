//lib/views/furniture_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/furniture_controller.dart';
import '../models/furniture.dart';
import 'furniture_detail_page.dart';
import 'add_furniture_page.dart';

class MueblesPage extends StatelessWidget {
  final FurnitureController _controller = FurnitureController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Muebles'),
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
              return ListTile(
                leading: Image.network(mueble.imagenURL, width: 50, height: 50),
                title: Text(mueble.nombre),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stock: ${mueble.stock}'),
                  ],
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MuebleDetailPage(mueble: mueble),
                    ),
                  );
                },
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
