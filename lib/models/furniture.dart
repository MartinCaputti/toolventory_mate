//lib/models/furniture.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Mueble {
  final String id;
  final String nombre;
  final String descripcion;
  final Map<String, int> productosNecesarios;
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
      productosNecesarios: Map<String, int>.from(doc['productosNecesarios']),
      imagenURL: doc['imagenURL'],
      stock: doc['stock'],
    );
  }
}
