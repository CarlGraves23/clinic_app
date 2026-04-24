import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';

class AppointmentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;

  List<AppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;

  Future<bool> bookAppointment(AppointmentModel appointment) async {
    _isLoading = true;
    notifyListeners();

    try {
      String docId = _firestore.collection('appointments').doc().id;
      appointment.id = docId;
      appointment.status = 'pending';
      appointment.createdAt = DateTime.now();
      
      await _firestore.collection('appointments').doc(docId).set(appointment.toJson());
      
      if (appointment.patientId != null) {
        await _loadAppointments(appointment.patientId!);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Book appointment error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _loadAppointments(String patientId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('appointments')
          .where('patientId', isEqualTo: patientId)
          .orderBy('appointmentDate', descending: false)
          .get();

      _appointments = snapshot.docs.map((doc) {
        return AppointmentModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Load appointments error: $e');
      _appointments = [];
      notifyListeners();
    }
  }

  Future<void> loadAppointments(String patientId) async {
    await _loadAppointments(patientId);
  }

  Future<bool> updateAppointment(AppointmentModel appointment) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _firestore
          .collection('appointments')
          .doc(appointment.id)
          .update(appointment.toJson());
      
      if (appointment.patientId != null) {
        await _loadAppointments(appointment.patientId!);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Update appointment error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAppointment(String appointmentId, String patientId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _firestore.collection('appointments').doc(appointmentId).delete();
      await _loadAppointments(patientId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Delete appointment error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<AppointmentModel?> getAppointmentById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('appointments').doc(id).get();
      if (doc.exists) {
        return AppointmentModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Get appointment error: $e');
      return null;
    }
  }
}