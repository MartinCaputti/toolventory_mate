//lib/views/furniture_detail_page.dart

import 'package:flutter/material.dart';
import '../models/furniture.dart';

class MuebleDetailPage extends StatelessWidget {
  final Mueble mueble;

  MuebleDetailPage({required this.mueble});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mueble.nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(mueble.imagenURL),
            SizedBox(height: 8.0),
            Text(mueble.descripcion, style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 8.0),
            Text('Stock: ${mueble.stock}', style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 16.0),
            Text('Productos Necesarios:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            for (var entry in mueble.productosNecesarios.entries)
              Text('${entry.key}: ${entry.value}',
                  style: TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}
