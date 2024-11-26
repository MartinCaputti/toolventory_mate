import '../models/category.dart';

class CategoryController {
  Future<void> addCategory(Categoria categoria) async {
    await categoria.save();
  }

  Future<List<Categoria>> getAllCategories() async {
    return await Categoria.getAll();
  }
}
