import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final String email;
  final String name;
  final String medicalId;
  DocumentReference? reference;

  Patient({required this.name, required this.email, required this.medicalId});

  factory Patient.fromJson(Map<dynamic, dynamic> json) => Patient(
      name: json['name'] as String,
      medicalId: json['medicalId'] as String,
      email: json['email'] as String);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'date': name,
        'medicalId': medicalId,
        'email': email,
      };

  factory Patient.fromSnapshot(DocumentSnapshot snapshot) {
    final doctor = Patient.fromJson(snapshot.data() as Map<String, dynamic>);
    doctor.reference = snapshot.reference;
    return doctor;
  }
}
