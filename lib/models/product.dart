//lib/models/product.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {
  final String? id;
  final String nombre;
  final String imagenURL;
  final int stock;
  final String? descripcion;
  final String categoria;

  Producto({
    this.id,
    required this.nombre,
    required this.imagenURL,
    required this.stock,
    this.descripcion,
    required this.categoria,
  });

  factory Producto.fromSnapshot(DocumentSnapshot doc) {
    return Producto(
      id: doc.id,
      nombre: doc['nombre'],
      imagenURL: doc['imagenURL'],
      stock: (doc['stock'] is int) ? doc['stock'] : int.parse(doc['stock']),
      descripcion: doc['descripcion'],
      categoria: doc['categoria'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'imagenURL': imagenURL,
      'stock': stock,
      'descripcion': descripcion,
      'categoria': categoria,
    };
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('productos');

  Future<void> save() async {
    if (id == null || id!.isEmpty) {
      DocumentReference docRef = await collection.add(toMap());
      await collection.doc(docRef.id).update({'id': docRef.id});
    } else {
      await collection.doc(id).update(toMap());
    }
  }

  Future<void> delete() async {
    await collection.doc(id).delete();
  }

  static Future<Producto> getById(String id) async {
    DocumentSnapshot doc = await collection.doc(id).get();
    return Producto.fromSnapshot(doc);
  }

  static Future<List<Producto>> getAll({int limit = 10}) async {
    QuerySnapshot snapshot =
        await collection.orderBy('nombre').limit(limit).get();
    return snapshot.docs.map((doc) => Producto.fromSnapshot(doc)).toList();
  }

  static Future<List<Producto>> getMore(DocumentSnapshot lastDocument,
      {int limit = 10}) async {
    QuerySnapshot snapshot = await collection
        .orderBy('nombre')
        .startAfterDocument(lastDocument)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => Producto.fromSnapshot(doc)).toList();
  }

  static Future<List<Producto>> getByCategory(String category,
      {int limit = 10}) async {
    QuerySnapshot snapshot = await collection
        .where('categoria', isEqualTo: category)
        .orderBy('nombre')
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => Producto.fromSnapshot(doc)).toList();
  }

  static Future<List<Producto>> getMoreByCategory(
      String category, DocumentSnapshot lastDocument,
      {int limit = 10}) async {
    QuerySnapshot snapshot = await collection
        .where('categoria', isEqualTo: category)
        .orderBy('nombre')
        .startAfterDocument(lastDocument)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => Producto.fromSnapshot(doc)).toList();
  }

  static Stream<QuerySnapshot> streamAll() {
    return collection.orderBy('nombre').snapshots();
  }

  static Stream<QuerySnapshot> streamByCategory(String category) {
    return collection
        .where('categoria', isEqualTo: category)
        .orderBy('nombre')
        .snapshots();
  }

  static Future<void> updateStock(String id, int newStock) async {
    await collection.doc(id).update({'stock': newStock});
  }
}
