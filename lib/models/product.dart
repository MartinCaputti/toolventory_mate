class Producto {
  final String?
      id; // // id nunca va a ser null porque firestore lo genera automaticamente , pero mi programa no lo sabe asi que tengo que aclarar que puede ser nulo

  final String nombre;
  final String imagenURL;
  final int stock;
  final String? descripcion;
  final String categoria;

  Producto({
    this.id, // El id es opcional para que Firestore lo genere automáticamente
    required this.nombre,
    required this.imagenURL,
    required this.stock,
    this.descripcion,
    required this.categoria,
  });

  // Método copyWith para actualizar atributos específicos.
  //https://api.flutter.dev/flutter/material/TextTheme/copyWith.html
  Producto copyWith(
      {String? id,
      String? nombre,
      String? imagenURL,
      int? stock,
      String? descripcion,
      String? categoria}) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      imagenURL: imagenURL ?? this.imagenURL,
      stock: stock ?? this.stock,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
    );
  }

  //Agregue las categorias despues
}
