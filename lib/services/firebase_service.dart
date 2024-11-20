//lib/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/category.dart';

class FirebaseService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('productos');
  //Agregue coleccion categorias despues
  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('categorias');

  Future<void> addProduct(Producto producto) async {
    DocumentReference docRef = await _productCollection.add({
      'nombre': producto.nombre,
      'imagenURL': producto.imagenURL,
      'stock': producto.stock,
      'descripcion': producto.descripcion,
      'categoria': producto.categoria,
    });
    await _productCollection.doc(docRef.id).update({'id': docRef.id});
  }

  Future<void> deleteProduct(String id) async {
    await _productCollection.doc(id).delete();
  }

  Future<void> updateProduct(String id, Producto producto) async {
    await _productCollection.doc(id).update({
      'nombre': producto.nombre,
      'imagenURL': producto.imagenURL,
      'stock': producto.stock,
      'descripcion': producto.descripcion,
      'categoria': producto.categoria,
    });
  }

  Future<void> updateStock(String id, int newStock) async {
    await _productCollection.doc(id).update({
      'stock': newStock, // Actualiza solo el stock
    });
  }

  Future<List<Producto>> getProducts() async {
    QuerySnapshot snapshot = await _productCollection.get();
    return snapshot.docs.map((doc) {
      return Producto(
        id: doc.id,
        nombre: doc['nombre'],
        imagenURL: doc['imagenURL'],
        stock: doc['stock'],
        descripcion: doc['descripcion'],
        categoria: doc['categoria'],
      );
    }).toList();
  }

  Stream<List<Producto>> productStream() {
    return _productCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Producto(
          id: doc.id,
          nombre: doc['nombre'],
          imagenURL: doc['imagenURL'],
          stock: doc['stock'],
          descripcion: doc['descripcion'],
          categoria: doc['categoria'],
        );
      }).toList();
    });
  }

  Future<void> addCategory(Categoria categoria) async {
    DocumentReference docRef = await _categoryCollection.add({
      'nombre': categoria.nombre,
      'imagenURL': categoria.imagenURL,
    });
    await _categoryCollection.doc(docRef.id).update({'id': docRef.id});
  }
}
