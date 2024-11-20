//lib/components/stock_controls.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';

class StockControls extends StatefulWidget {
  final Producto producto;
  final ProductController controller;
  final Function(int)
      onStockChanged; // Callback para notificar cambios en el stock.

  StockControls(
      {required this.producto,
      required this.controller,
      required this.onStockChanged});

  @override
  _StockControlsState createState() => _StockControlsState();
}

class _StockControlsState extends State<StockControls> {
  late int currentStock;

  @override
  void initState() {
    super.initState();
    currentStock = widget.producto.stock; // Inicializa el stock actual.
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Stock: $currentStock',
          style: TextStyle(
              fontSize: 14, color: const Color.fromARGB(255, 41, 41, 41)),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () =>
                  updateStock(currentStock - 1), // Decrementa el stock.
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  updateStock(currentStock + 1), // Incrementa el stock.
            ),
          ],
        ),
      ],
    );
  }

  // Función para actualizar el stock.
  Future<void> updateStock(int newStock) async {
    if (newStock < 0) return; // Evitar valores negativos.
    setState(() {
      currentStock = newStock; // Actualiza el estado localmente.
    });
    await widget.controller.updateStock(widget.producto.id!,
        newStock); // Llama al controlador para actualizar solo el stock.
    widget.onStockChanged(
        newStock); // Notifica al parent sobre el cambio de stock.
  }
}
