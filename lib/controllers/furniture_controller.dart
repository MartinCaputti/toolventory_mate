//lib/controllers/furniture_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/furniture.dart';
import '../services/firebase_service.dart';

class FurnitureController {
  final FirebaseService _firebaseService = FirebaseService();

  Stream<QuerySnapshot> streamMuebles() {
    return _firebaseService.streamMuebles();
  }

  Future<void> addMueble(Mueble mueble) async {
    await _firebaseService.addMueble(mueble);
  }

  Future<void> deleteMueble(String muebleId) async {
    await _firebaseService.deleteMueble(muebleId);
  }

  Future<void> updateMueble(String muebleId, Mueble mueble) async {
    await _firebaseService.updateMueble(muebleId, mueble);
  }

  Future<DocumentSnapshot> getMuebleById(String muebleId) async {
    return await _firebaseService.getMuebleById(muebleId);
  }

  Future<void> updateMuebleStock(String muebleId, int newStock) async {
    await _firebaseService.updateMuebleStock(muebleId, newStock);
  }
}
