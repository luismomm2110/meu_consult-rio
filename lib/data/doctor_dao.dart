import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor.dart';

class DoctorDao {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('doctors');

  void saveDoctor(Doctor doctor) {
    collection.add(doctor.toJson());
  }

  Stream<QuerySnapshot> getDoctorStream() {
    return collection.snapshots();
  }
}
