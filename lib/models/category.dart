//lib/models/category.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Categoria {
  final String id;
  final String nombre;
  final String imagenURL;

  Categoria({
    required this.id,
    required this.nombre,
    required this.imagenURL,
  });

  factory Categoria.fromSnapshot(DocumentSnapshot doc) {
    return Categoria(
      id: doc.id,
      nombre: doc['nombre'],
      imagenURL: doc['imagenURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'imagenURL': imagenURL,
    };
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('categorias');

  Future<void> save() async {
    if (id.isEmpty) {
      DocumentReference docRef = await collection.add(toMap());
      await collection.doc(docRef.id).update({'id': docRef.id});
    } else {
      await collection.doc(id).update(toMap());
    }
  }

  static Future<List<Categoria>> getAll() async {
    QuerySnapshot snapshot = await collection.get();
    return snapshot.docs.map((doc) => Categoria.fromSnapshot(doc)).toList();
  }
}
