// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
      name: json['name'] as String,
      email: json['email'] as String,
      charts: (json['charts'] as List<dynamic>?)
          ?.map((e) => Chart.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'charts': instance.charts?.map((e) => e.toJson()).toList(),
    };
