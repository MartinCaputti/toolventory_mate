//Controllers/product_controller.dart
import '../models/product.dart';
import '../services/firebase_service.dart';

class ProductController {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<Producto>> fetchProducts() async {
    return await _firebaseService.getProducts();
  }

  Future<void> addProduct(Producto producto) async {
    await _firebaseService.addProduct(producto);
  }

  Stream<List<Producto>> productStream() {
    return _firebaseService.productStream();
  }

  Future<void> deleteProduct(String id) async {
    // Controlador que llama a deleteProduct en FirebaseService para eliminar un producto.
    await _firebaseService.deleteProduct(id);
  }
}
