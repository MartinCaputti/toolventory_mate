//lib/controllers/furniture_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/furniture.dart';

class FurnitureController {
  Stream<QuerySnapshot> streamMuebles() {
    return Mueble.streamAll();
  }

  Future<void> addMueble(Mueble mueble) async {
    await mueble.save();
  }

  Future<void> deleteMueble(String muebleId) async {
    Mueble mueble = await Mueble.getById(muebleId);
    await mueble.delete();
  }

  Future<void> updateMueble(Mueble mueble) async {
    await mueble.save();
  }

  Future<Mueble> getMuebleById(String muebleId) async {
    return await Mueble.getById(muebleId);
  }

  Future<void> updateMuebleStock(String muebleId, int newStock) async {
    await Mueble.updateStock(muebleId, newStock);
  }
}
