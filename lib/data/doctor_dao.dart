import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor.dart';

class DoctorDao {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('doctors');

  void saveDoctor(Patient doctor) {
    collection.add(doctor.toJson());
  }

  Stream<QuerySnapshot> getDoctorStream() {
    return collection.snapshots();
  }

  Future<bool> isUserDoctor(String email) async {
    final QuerySnapshot result = await collection
        .where('email', isEqualTo: email)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

}
