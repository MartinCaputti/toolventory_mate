//lib/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirebaseService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('productos');

  Future<void> addProduct(Producto producto) async {
    await _productCollection.add({
      'nombre': producto.nombre,
      'imagenURL': producto.imagenURL,
      'stock': producto.stock,
      'descripcion': producto.descripcion,
    });
  }

  Future<List<Producto>> getProducts() async {
    QuerySnapshot snapshot = await _productCollection.get();
    return snapshot.docs.map((doc) {
      return Producto(
        nombre: doc['nombre'],
        imagenURL: doc['imagenURL'],
        stock: doc['stock'],
        descripcion: doc['descripcion'],
      );
    }).toList();
  }

  Stream<List<Producto>> productStream() {
    return _productCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Producto(
          nombre: doc['nombre'],
          imagenURL: doc['imagenURL'],
          stock: doc['stock'],
          descripcion: doc['descripcion'],
        );
      }).toList();
    });
  }

  Future<void> deleteProduct(String id) async {
    // Funcion para borrar por ID en caso de que haya una entrada erronea o de prueba
    await _productCollection.doc(id).delete();
  }
}
