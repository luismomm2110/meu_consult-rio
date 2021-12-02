import 'package:cloud_firestore/cloud_firestore.dart';

class Chart {
  final String text;
  final DateTime date;

  DocumentReference? reference;

  Chart({required this.text, required this.date});

  factory Chart.fromJson(Map<dynamic, dynamic> json) => Chart(
      text: json['text'] as String,
      date: DateTime.parse(json['date'] as String));

  Map<String, dynamic> toJson() => <String, dynamic>{
        'date': date.toString(),
        'text': text,
      };

  factory Chart.fromSnapshot(DocumentSnapshot snapshot) {
    final chart = Chart.fromJson(snapshot.data() as Map<String, dynamic>);
    chart.reference = snapshot.reference;
    return chart;
  }
}
