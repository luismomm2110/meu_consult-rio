import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meu_consultorio/data/doctor_dao.dart';
import 'package:meu_consultorio/models/appointment.dart';

part 'doctor.g.dart';

@JsonSerializable(explicitToJson: true)
class Doctor {
  final String email;
  final String name;
  final String medicalId;
  List<Appointment>? appointments;

  Doctor({required this.name, required this.email, required this.medicalId});

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorToJson(this);

  factory Doctor.fromSnapshot(DocumentSnapshot snapshot) {
    final doctor = Doctor.fromJson(snapshot.data() as Map<String, dynamic>);
    return doctor;
  }

  static Future<Doctor> fromEmail(String email) async {
    final patientSnapshot = await DoctorDao().getDoctorSnapshotByEmail(email);
    return Doctor.fromSnapshot(patientSnapshot);
  }
}
