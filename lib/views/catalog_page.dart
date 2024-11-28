//lib/viws/catalog_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import 'add_product_page.dart';
import '../components/grid_product_view.dart';
import '../components/list_product_view.dart';

class CatalogoPage extends StatefulWidget {
  final String? category; // Categoría opcional para filtrar productos

  CatalogoPage({this.category});

  @override
  _CatalogoPageState createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  final ProductController _controller =
      ProductController(); // Controlador para manejar productos
  bool _isGridView =
      true; // Bandera para cambiar entre vista de cuadrícula y lista

  // Método para alternar la vista entre cuadrícula y lista
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
            ? 'Productos en ${widget.category}' // Título de la AppBar con categoría
            : 'Inventario de Productos'), // Título general
        actions: [
          IconButton(
            icon: Icon(_isGridView
                ? Icons.view_list
                : Icons.view_module), // Icono para alternar la vista
            onPressed: _toggleView,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Escucha cambios en la colección de productos, filtrados por categoría si está presente
        stream: widget.category != null
            ? _controller.streamProductsByCategory(widget.category!)
            : _controller.streamProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()); // Indicador de carga
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Mensaje de error
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
                    'No hay productos')); // Mensaje cuando no hay productos
          }

          // Convierte los documentos de Firestore en una lista de objetos Producto
          List<Producto> productos = snapshot.data!.docs
              .map((doc) => Producto.fromSnapshot(doc))
              .toList();

          return Column(
            children: [
              Expanded(
                // Muestra los productos en una vista de cuadrícula o lista, según la bandera _isGridView
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
      // Muestra un FloatingActionButton para agregar productos
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
