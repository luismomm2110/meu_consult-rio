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

  Future<bool> isUserPatient(String email) async {
    final QuerySnapshot result =
        await collection.where('email', isEqualTo: email).get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }
}
