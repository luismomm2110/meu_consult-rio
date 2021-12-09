// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chart _$ChartFromJson(Map<String, dynamic> json) => Chart(
      doctorName: json['doctorName'] as String,
      medicalID: json['medicalID'] as String,
      text: json['text'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$ChartToJson(Chart instance) => <String, dynamic>{
      'text': instance.text,
      'date': instance.date.toIso8601String(),
      'doctorName': instance.doctorName,
      'medicalID': instance.medicalID,
    };
