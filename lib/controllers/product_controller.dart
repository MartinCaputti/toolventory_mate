//lib/controllers/product_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductController {
  Stream<QuerySnapshot> streamProducts() {
    return Producto.streamAll();
  }

  Stream<QuerySnapshot> streamProductsByCategory(String category) {
    return Producto.streamByCategory(category);
  }

  Future<void> addProduct(Producto producto) async {
    await producto.save();
  }

  Future<void> deleteProduct(String productId) async {
    Producto producto = await Producto.getById(productId);
    await producto.delete();
  }

  Future<void> updateProduct(Producto producto) async {
    await producto.save();
  }

  Future<List<Producto>> fetchProducts({int limit = 10}) async {
    return await Producto.getAll(limit: limit);
  }

  Future<List<Producto>> fetchMoreProducts(
      {DocumentSnapshot? lastDocument, int limit = 10}) async {
    return await Producto.getMore(lastDocument!, limit: limit);
  }

  Future<List<Producto>> fetchProductsByCategory(String category,
      {int limit = 10}) async {
    return await Producto.getByCategory(category, limit: limit);
  }

  Future<List<Producto>> fetchMoreProductsByCategory(
      String category, DocumentSnapshot lastDocument,
      {int limit = 10}) async {
    return await Producto.getMoreByCategory(category, lastDocument,
        limit: limit);
  }

  Future<void> updateStockForFurniture(
      String productId, int quantityUsed) async {
    Producto producto = await Producto.getById(productId);
    int newStock = producto.stock - quantityUsed;
    await Producto.updateStock(productId, newStock);
  }

  Future<Producto> getProductById(String productId) async {
    return await Producto.getById(productId);
  }
}
