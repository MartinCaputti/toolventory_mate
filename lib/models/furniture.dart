//lib/models/furniture.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Mueble {
  final String id;
  final String nombre;
  final String descripcion;
  final Map<String, Map<String, dynamic>> productosNecesarios;
  final String imagenURL;
  final int stock;

  Mueble({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.productosNecesarios,
    required this.imagenURL,
    required this.stock,
  });

  factory Mueble.fromSnapshot(DocumentSnapshot doc) {
    return Mueble(
      id: doc.id,
      nombre: doc['nombre'],
      descripcion: doc['descripcion'],
      productosNecesarios:
          Map<String, Map<String, dynamic>>.from(doc['productosNecesarios']),
      imagenURL: doc['imagenURL'],
      stock: doc['stock'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': capitalizeFirstLetter(
          nombre), // Capitalizar la primera letra al guardarlo
      'descripcion': descripcion,
      'productosNecesarios': productosNecesarios,
      'imagenURL': imagenURL,
      'stock': stock,
    };
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('muebles');

  Future<void> save() async {
    if (id.isEmpty) {
      DocumentReference docRef = await collection.add(toMap());
      await collection.doc(docRef.id).update({'id': docRef.id});
    } else {
      await collection.doc(id).update(toMap());
    }
  }

  Future<void> delete() async {
    await collection.doc(id).delete();
  }

  static Future<Mueble> getById(String id) async {
    DocumentSnapshot doc = await collection.doc(id).get();
    return Mueble.fromSnapshot(doc);
  }

  static Future<List<Mueble>> getAll({int limit = 10}) async {
    QuerySnapshot snapshot =
        await collection.orderBy('nombre').limit(limit).get();
    return snapshot.docs.map((doc) => Mueble.fromSnapshot(doc)).toList();
  }

  static Future<List<Mueble>> getMore(DocumentSnapshot lastDocument,
      {int limit = 10}) async {
    QuerySnapshot snapshot = await collection
        .orderBy('nombre')
        .startAfterDocument(lastDocument)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => Mueble.fromSnapshot(doc)).toList();
  }

  static Stream<QuerySnapshot> streamAll() {
    return collection.orderBy('nombre').snapshots();
  }

  static Future<void> updateStock(String id, int newStock) async {
    await collection.doc(id).update({'stock': newStock});
  }

  // Función para capitalizar la primera letra
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
