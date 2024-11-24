import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../services/firebase_service.dart';

class ProductController {
  final FirebaseService _firebaseService = FirebaseService();

  Stream<QuerySnapshot<Object?>> streamProducts() {
    return _firebaseService.streamProducts();
  }

  Stream<QuerySnapshot<Object?>> streamProductsByCategory(String category) {
    return _firebaseService.streamProductsByCategory(category);
  }

  Future<void> addProduct(Producto producto) async {
    await _firebaseService.addProduct(producto);
  }

  Future<void> deleteProduct(String productId) async {
    await _firebaseService.deleteProduct(productId);
  }

  Future<void> updateProduct(String productId, Producto producto) async {
    await _firebaseService.updateProduct(productId, producto);
  }

  Future<void> updateStock(String productId, int newStock) async {
    await _firebaseService.updateStock(productId, newStock);
  }

  Future<List<Producto>> fetchProducts({int limit = 10}) async {
    QuerySnapshot<Object?> snapshot =
        await _firebaseService.getProducts(limit: limit);
    return _firebaseService.convertSnapshotToProducts(snapshot);
  }

  Future<List<Producto>> fetchMoreProducts(
      {DocumentSnapshot<Object?>? lastDocument, int limit = 10}) async {
    QuerySnapshot<Object?> snapshot = await _firebaseService.getMoreProducts(
        lastDocument: lastDocument, limit: limit);
    return _firebaseService.convertSnapshotToProducts(snapshot);
  }

  Future<List<Producto>> fetchProductsByCategory(String category,
      {int limit = 10}) async {
    QuerySnapshot<Object?> snapshot =
        await _firebaseService.getProductsByCategory(category, limit: limit);
    return _firebaseService.convertSnapshotToProducts(snapshot);
  }

  Future<List<Producto>> fetchMoreProductsByCategory(String category,
      {DocumentSnapshot<Object?>? lastDocument, int limit = 10}) async {
    QuerySnapshot<Object?> snapshot =
        await _firebaseService.getMoreProductsByCategory(category,
            lastDocument: lastDocument, limit: limit);
    return _firebaseService.convertSnapshotToProducts(snapshot);
  }

  Future<void> updateStockForFurniture(
      String productId, int quantityUsed) async {
    DocumentSnapshot productDoc =
        await _firebaseService.getProductById(productId);
    Producto producto = Producto.fromSnapshot(productDoc);
    int newStock = producto.stock -
        quantityUsed; // Restar la cantidad usada del stock actual
    await _firebaseService.updateStock(productId, newStock);
  }

  Future<DocumentSnapshot> getProductById(String productId) async {
    return await _firebaseService.getProductById(productId);
  }
}
