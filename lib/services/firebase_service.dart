//lib/services/firebase_service.dart
import 'package:firebase_database/firebase_database.dart';
import '../models/product.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> addProduct(Producto producto) async {
    await _dbRef.child('productos').push().set({
      'nombre': producto.nombre,
      'imagenUrl': producto.imagenUrl,
      'stock': producto.stock,
    });
  }

  Future<List<Producto>> getProducts() async {
    DataSnapshot snapshot = await _dbRef.child('productos').get();
    List<Producto> products = [];
    for (var product in snapshot.children) {
      products.add(Producto(
        nombre: product.child('nombre').value.toString(),
        imagenUrl: product.child('imagenUrl').value.toString(),
        stock: int.parse(product.child('stock').value.toString()),
      ));
    }
    return products;
  }
}
