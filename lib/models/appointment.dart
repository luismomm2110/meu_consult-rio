import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

@JsonSerializable()
class Appointment {
  final DateTime date;
  final String patientName;

  Appointment({required this.patientName, required this.date});

  factory Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);

  factory Appointment.fromSnapshot(DocumentSnapshot snapshot) {
    final chart = Appointment.fromJson(snapshot.data() as Map<String, dynamic>);
    return chart;
  }
}
