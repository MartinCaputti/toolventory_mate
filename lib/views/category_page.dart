import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'category_products_page.dart';
import '../models/category.dart';
import '../components/product_image.dart'; // Importar el widget ProductImage

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('categorias').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var categorias = snapshot.data!.docs.map((doc) {
            return Categoria(
              id: doc.id,
              nombre: doc['nombre'],
              imagenURL: doc['imagenURL'],
            );
          }).toList();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              var categoria = categorias[index];
              return CategoryCard(categoria: categoria);
            },
          );
        },
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Categoria categoria;

  CategoryCard({required this.categoria});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CategoryProductsPage(category: categoria.nombre)),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProductImage(
                imagenURL:
                    categoria.imagenURL), // Utiliza el widget ProductImage
            SizedBox(height: 10),
            Text(categoria.nombre),
          ],
        ),
      ),
    );
  }
}
