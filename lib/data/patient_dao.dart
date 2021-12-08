import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient.dart';

class PatientDao {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('patients');

  void savePatient(Patient patient) {
    collection.add(patient.toJson());
  }

  Stream<QuerySnapshot> getPatientStream() {
    return collection.snapshots();
  }

  Future<void> updatePatient(Patient patient) async {
    final patientReference = await _getPatientReferenceByEmail(patient.email);
    patientReference.update(patient.toJson());
  }

  Future<DocumentReference<Object?>> _getPatientReferenceByEmail(
      String email) async {
    final QuerySnapshot result =
        await collection.where('email', isEqualTo: email).get();
    final patientReference = result.docs.first.reference;
    return patientReference;
  }

  Future<DocumentSnapshot<Object?>> getPatientSnapshotByEmail(
      String email) async {
    final QuerySnapshot result =
        await collection.where('email', isEqualTo: email).get();
    final patientSnapshot =
        await result.docs.first.reference.snapshots().first;
    return patientSnapshot;
  }

  Future<bool> isUserPatient(String email) async {
    final QuerySnapshot result =
        await collection.where('email', isEqualTo: email).get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }
}
