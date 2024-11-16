import 'package:flutter/material.dart';
import '../components/product_card.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';

class CatalogoPage extends StatefulWidget {
  @override
  _CatalogoPageState createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  final ProductController _controller = ProductController();
  List<Producto> _productos = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    _productos = await _controller.fetchProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario de Productos'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _productos.length,
        itemBuilder: (context, index) {
          return ProductCard(producto: _productos[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para añadir nuevos productos
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
