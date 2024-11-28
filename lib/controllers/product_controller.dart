//lib/controllers/product_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore
import '../models/product.dart'; // Importa el modelo de producto

// Clase que controla las operaciones relacionadas con los productos
class ProductController {
  // Método para transmitir todos los productos como un flujo de datos
  Stream<QuerySnapshot> streamProducts() {
    return Producto.streamAll();
  }

  // Método para transmitir los productos filtrados por categoría como un flujo de datos
  Stream<QuerySnapshot> streamProductsByCategory(String category) {
    return Producto.streamByCategory(category);
  }

  // Método para agregar un nuevo producto
  Future<void> addProduct(Producto producto) async {
    await producto.save();
  }

  // Método para eliminar un producto por su ID
  Future<void> deleteProduct(String productId) async {
    Producto producto = await Producto.getById(productId);
    await producto.delete();
  }

  // Método para actualizar un producto
  Future<void> updateProduct(Producto producto) async {
    await producto.save();
  }

  // Método para obtener una lista de productos con un límite de cantidad
  Future<List<Producto>> fetchProducts({int limit = 10}) async {
    return await Producto.getAll(limit: limit);
  }

  // Método para obtener más productos a partir de un documento específico
  Future<List<Producto>> fetchMoreProducts(
      {DocumentSnapshot? lastDocument, int limit = 10}) async {
    return await Producto.getMore(lastDocument!, limit: limit);
  }

  // Método para obtener productos por categoría con un límite de cantidad
  Future<List<Producto>> fetchProductsByCategory(String category,
      {int limit = 10}) async {
    return await Producto.getByCategory(category, limit: limit);
  }

  // Método para obtener más productos por categoría a partir de un documento específico
  Future<List<Producto>> fetchMoreProductsByCategory(
      String category, DocumentSnapshot lastDocument,
      {int limit = 10}) async {
    return await Producto.getMoreByCategory(category, lastDocument,
        limit: limit);
  }

  // Método para actualizar el stock de un producto utilizado en la fabricación de muebles
  Future<void> updateStockForFurniture(
      String productId, int quantityUsed) async {
    Producto producto = await Producto.getById(productId);
    int newStock = producto.stock - quantityUsed;
    await Producto.updateStock(productId, newStock);
  }

  // Método para obtener un producto por su ID
  Future<Producto> getProductById(String productId) async {
    return await Producto.getById(productId);
  }
}
