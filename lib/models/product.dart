//lib/models/product.dart

import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore

// Clase que representa un Producto
class Producto {
  final String? id; // ID del producto, puede ser null
  final String nombre; // Nombre del producto
  final String imagenURL; // URL de la imagen del producto
  final int stock; // Cantidad en stock del producto
  final String? descripcion; // Descripción del producto, puede ser null
  final String categoria; // Categoría del producto

  Producto({
    this.id,
    required this.nombre,
    required this.imagenURL,
    required this.stock,
    this.descripcion,
    required this.categoria,
  });

  // Fábrica para crear una instancia de Producto a partir de un DocumentSnapshot
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

  // Convierte el producto a un mapa de datos
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'imagenURL': imagenURL,
      'stock': stock,
      'descripcion': descripcion,
      'categoria': categoria,
    };
  }

  // Obtiene la referencia a la colección de productos en Firestore
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('productos');

  // Guarda el producto en Firestore
  Future<void> save() async {
    if (id == null || id!.isEmpty) {
      DocumentReference docRef = await collection.add(toMap());
      await collection.doc(docRef.id).update({'id': docRef.id});
    } else {
      await collection.doc(id).update(toMap());
    }
  }

  // Elimina el producto de Firestore
  Future<void> delete() async {
    await collection.doc(id).delete();
  }

  // Obtiene un producto por su ID
  static Future<Producto> getById(String id) async {
    DocumentSnapshot doc = await collection.doc(id).get();
    return Producto.fromSnapshot(doc);
  }

  // Obtiene todos los productos con un límite opcional
  static Future<List<Producto>> getAll({int limit = 10}) async {
    QuerySnapshot snapshot =
        await collection.orderBy('nombre').limit(limit).get();
    return snapshot.docs.map((doc) => Producto.fromSnapshot(doc)).toList();
  }

  // Obtiene más productos a partir de un documento específico con un límite opcional
  static Future<List<Producto>> getMore(DocumentSnapshot lastDocument,
      {int limit = 10}) async {
    QuerySnapshot snapshot = await collection
        .orderBy('nombre')
        .startAfterDocument(lastDocument)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => Producto.fromSnapshot(doc)).toList();
  }

  // Obtiene productos por categoría con un límite opcional
  static Future<List<Producto>> getByCategory(String category,
      {int limit = 10}) async {
    QuerySnapshot snapshot = await collection
        .where('categoria', isEqualTo: category)
        .orderBy('nombre')
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => Producto.fromSnapshot(doc)).toList();
  }

  // Obtiene más productos por categoría a partir de un documento específico con un límite opcional
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

  // Transmite todos los productos como un flujo de datos
  static Stream<QuerySnapshot> streamAll() {
    return collection.orderBy('nombre').snapshots();
  }

  // Transmite productos por categoría como un flujo de datos
  static Stream<QuerySnapshot> streamByCategory(String category) {
    return collection
        .where('categoria', isEqualTo: category)
        .orderBy('nombre')
        .snapshots();
  }

  // Actualiza el stock de un producto
  static Future<void> updateStock(String id, int newStock) async {
    await collection.doc(id).update({'stock': newStock});
  }
}
