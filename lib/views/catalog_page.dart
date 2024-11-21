import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import 'add_product_page.dart';
import '../components/grid_product_view.dart';
import '../components/list_product_view.dart';

class CatalogoPage extends StatefulWidget {
  final String? category;

  CatalogoPage({this.category});

  @override
  _CatalogoPageState createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  final ProductController _controller = ProductController();
  bool _isGridView = true;

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category != null
            ? 'Productos en ${widget.category}'
            : 'Inventario de Productos'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.view_module),
            onPressed: _toggleView,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.category != null
            ? _controller.streamProductsByCategory(widget.category!)
            : _controller.streamProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay productos'));
          }

          List<Producto> productos = snapshot.data!.docs
              .map((doc) => Producto.fromSnapshot(doc))
              .toList();

          return Column(
            children: [
              Expanded(
                child: _isGridView
                    ? GridProductView(
                        productos: productos,
                        isLoading: false,
                        hasMore: false,
                        fetchMoreProducts: () {},
                        controller: _controller,
                      )
                    : ListProductView(
                        productos: productos,
                        isLoading: false,
                        hasMore: false,
                        fetchMoreProducts: () {},
                        controller: _controller,
                        onDelete: (int index) {
                          setState(() {
                            productos.removeAt(index);
                          });
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: widget.category == null
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductPage()),
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
