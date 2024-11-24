//lib/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/furniture.dart';

class FirebaseService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('productos');
  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('categorias');
  final CollectionReference _muebleCollection =
      FirebaseFirestore.instance.collection('muebles');

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
      'stock': newStock,
    });
  }

  Future<QuerySnapshot<Object?>> getProducts({int limit = 10}) async {
    return await _productCollection.orderBy('nombre').limit(limit).get();
  }

  Future<QuerySnapshot<Object?>> getMoreProducts(
      {DocumentSnapshot<Object?>? lastDocument, int limit = 10}) async {
    return await _productCollection
        .orderBy('nombre')
        .startAfterDocument(lastDocument!)
        .limit(limit)
        .get();
  }

  Future<QuerySnapshot<Object?>> getProductsByCategory(String category,
      {int limit = 10}) async {
    return await _productCollection
        .where('categoria', isEqualTo: category)
        .orderBy('nombre')
        .limit(limit)
        .get();
  }

  Future<QuerySnapshot<Object?>> getMoreProductsByCategory(String category,
      {DocumentSnapshot<Object?>? lastDocument, int limit = 10}) async {
    return await _productCollection
        .where('categoria', isEqualTo: category)
        .orderBy('nombre')
        .startAfterDocument(lastDocument!)
        .limit(limit)
        .get();
  }

  List<Producto> convertSnapshotToProducts(QuerySnapshot<Object?> snapshot) {
    return snapshot.docs.map((doc) => Producto.fromSnapshot(doc)).toList();
  }

  Stream<QuerySnapshot<Object?>> streamProducts() {
    return _productCollection.orderBy('nombre').snapshots();
  }

  Stream<QuerySnapshot<Object?>> streamProductsByCategory(String category) {
    return _productCollection
        .where('categoria', isEqualTo: category)
        .orderBy('nombre')
        .snapshots();
  }

  Future<void> addCategory(Categoria categoria) async {
    DocumentReference docRef = await _categoryCollection.add({
      'nombre': categoria.nombre,
      'imagenURL': categoria.imagenURL,
    });
    await _categoryCollection.doc(docRef.id).update({'id': docRef.id});
  }

  //Metodos para muebles
  Future<void> addMueble(Mueble mueble) async {
    DocumentReference docRef = await _muebleCollection.add({
      'nombre': mueble.nombre,
      'descripcion': mueble.descripcion,
      'productosNecesarios': mueble.productosNecesarios,
      'imagenURL': mueble.imagenURL,
      'stock': mueble.stock,
    });
    await _muebleCollection.doc(docRef.id).update({'id': docRef.id});
  }

  Future<void> deleteMueble(String id) async {
    await _muebleCollection.doc(id).delete();
  }

  Future<void> updateMueble(String id, Mueble mueble) async {
    await _muebleCollection.doc(id).update({
      'nombre': mueble.nombre,
      'descripcion': mueble.descripcion,
      'productosNecesarios': mueble.productosNecesarios,
      'imagenURL': mueble.imagenURL,
      'stock': mueble.stock,
    });
  }

  Future<DocumentSnapshot> getMuebleById(String id) async {
    return await _muebleCollection.doc(id).get();
  }

  Future<QuerySnapshot> getMuebles({int limit = 10}) async {
    return await _muebleCollection.orderBy('nombre').limit(limit).get();
  }

  Future<QuerySnapshot> getMoreMuebles(
      {DocumentSnapshot? lastDocument, int limit = 10}) async {
    return await _muebleCollection
        .orderBy('nombre')
        .startAfterDocument(lastDocument!)
        .limit(limit)
        .get();
  }

  Stream<QuerySnapshot> streamMuebles() {
    return _muebleCollection.orderBy('nombre').snapshots();
  }

  Future<DocumentSnapshot> getProductById(String id) async {
    return await _productCollection.doc(id).get();
  }
}
