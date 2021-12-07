import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_consultorio/models/chart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient_model.g.dart';

@JsonSerializable
class Patient {
  final String email;
  final String name;
  List<Chart>? charts;
  DocumentReference? reference;

  Patient({required this.name, required this.email, required List<Chart> charts});

  factory Patient.fromJson(Map<dynamic, dynamic> json) {
    List list = json['charts'];

    List<Chart> dataCharts = list.map((i) => Chart.fromJson(i)).toList();

   return Patient(charts: dataCharts, name: json['name'] as String, email: json['email'] as String);
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'date': name,
        'email': email,
      };

  factory Patient.fromSnapshot(DocumentSnapshot snapshot) {
    final patient = Patient.fromJson(snapshot.data() as Map<String, dynamic>);
    patient.reference = snapshot.reference;
    return patient;
  }
}
