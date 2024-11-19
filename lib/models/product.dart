class Producto {
  final String?
      id; // // id nunca va a ser null porque firestore lo genera automaticamente , pero mi programa no lo sabe asi que tengo que aclarar que puede ser nulo

  final String nombre;
  final String imagenURL;
  final int stock;
  final String? descripcion;
  Producto({
    this.id, // El id es opcional para que Firestore lo genere automáticamente
    required this.nombre,
    required this.imagenURL,
    required this.stock,
    this.descripcion,
  });
}
