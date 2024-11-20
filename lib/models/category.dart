//lib/models/category.dart

class Categoria {
  final String? id;
  final String nombre;
  final String imagenURL;
  Categoria({
    this.id,
    required this.nombre,
    required this.imagenURL,
  });
  Categoria copyWith({String? id, String? nombre, String? imagenURL}) {
    return Categoria(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      imagenURL: imagenURL ?? this.imagenURL,
    );
  }
}
