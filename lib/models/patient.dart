import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_consultorio/data/patient_dao.dart';
import 'package:meu_consultorio/models/chart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient.g.dart';

@JsonSerializable(explicitToJson: true)
class Patient {
  final String email;
  final String name;
  List<Chart>? charts;

  Patient({required this.name, required this.email, this.charts});

  addChart(Chart chart) {
    if (this.charts == null) {
      this.charts = <Chart>[];
      this.charts!.add(chart);
    } else {
      this.charts!.add(chart);
    }
  }

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);

  Map<String, dynamic> toJson() => _$PatientToJson(this);

  factory Patient.fromSnapshot(DocumentSnapshot snapshot) {
    final patient = Patient.fromJson(snapshot.data() as Map<String, dynamic>);
    return patient;
  }

  static Future<Patient> fromEmail(String email) async {
    final patientSnapshot = await PatientDao().getPatientSnapshotByEmail(email);
    return Patient.fromSnapshot(patientSnapshot);
  }
}
