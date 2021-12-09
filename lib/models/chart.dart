import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chart.g.dart';

@JsonSerializable()
class Chart {
  final String text;
  final DateTime date;
  final String doctorName;
  final String medicalID;

  Chart({required this.doctorName, required this.medicalID, required this.text, required this.date});

  factory Chart.fromJson(Map<String, dynamic> json) => _$ChartFromJson(json);

  Map<String, dynamic> toJson() => _$ChartToJson(this);

  factory Chart.fromSnapshot(DocumentSnapshot snapshot) {
    final chart = Chart.fromJson(snapshot.data() as Map<String, dynamic>);
    return chart;
  }
}
