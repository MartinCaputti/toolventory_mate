//lib/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirebaseService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('productos');

  Future<void> addProduct(Producto producto) async {
    DocumentReference docRef = await _productCollection.add({
      'nombre': producto.nombre,
      'imagenURL': producto.imagenURL,
      'stock': producto.stock,
      'descripcion': producto.descripcion,
    });
    await _productCollection.doc(docRef.id).update({
      'id': docRef.id
    }); //Actualiza el documento con el id generado ,sin esto el uptade explota
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
        );
      }).toList();
    });
  }
}
