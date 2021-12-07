import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_consultorio/data/doctor_dao.dart';

class Doctor {
  final String email;
  final String name;
  final String medicalId;
  DocumentReference? reference;

  Doctor({required this.name, required this.email, required this.medicalId});

  factory Doctor.fromJson(Map<dynamic, dynamic> json) => Doctor(
      name: json['name'] as String,
      medicalId: json['medicalId'] as String,
      email: json['email'] as String);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'date': name,
        'medicalId': medicalId,
        'email': email,
      };

  factory Doctor.fromSnapshot(DocumentSnapshot snapshot) {
    final doctor = Doctor.fromJson(snapshot.data() as Map<String, dynamic>);
    doctor.reference = snapshot.reference;
    return doctor;
  }
}
