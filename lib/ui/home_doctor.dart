import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_consultorio/data/patient_dao.dart';
import 'package:meu_consultorio/data/user_dao.dart';
import 'package:meu_consultorio/models/doctor.dart';
import 'package:meu_consultorio/models/patient.dart';
import 'package:provider/provider.dart';
import '../models/chart.dart';

class HomeDoctor extends StatefulWidget {
  const HomeDoctor({Key? key}) : super(key: key);

  @override
  HomeDoctorState createState() => HomeDoctorState();
}

class HomeDoctorState extends State<HomeDoctor> {
  final TextEditingController _chartController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final auth = FirebaseAuth.instance;
  String _patientEmail = "";
  String? email;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    final userDao = Provider.of<UserDao>(context, listen: false);
    final patientDao = PatientDao();

    return Scaffold(
      appBar: AppBar(
        title: const Text("MyClinic"),
        actions: [
          IconButton(
            onPressed: () {
              userDao.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: listOfPatients(patientDao),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _chartController,
                      onSubmitted: (input) {
                        _sendPatient(patientDao, userDao);
                      },
                      decoration:
                          const InputDecoration(hintText: 'Enter new recipe'),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(_canSendChart()
                        ? CupertinoIcons.arrow_right_circle_fill
                        : CupertinoIcons.arrow_right_circle),
                    onPressed: () {
                      _sendPatient(patientDao, userDao);
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> listOfPatients(PatientDao patientDao) {
    return StreamBuilder<QuerySnapshot>(
        stream: patientDao.getPatientStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: LinearProgressIndicator());
          } else {
            return DropdownButtonFormField<String>(
              value: null,
              items: snapshot.data!.docs.map<DropdownMenuItem<String>>((data) {
                final patient = Patient.fromSnapshot(data);
                return DropdownMenuItem<String>(
                  value: patient.email,
                  child: Text(patient.name),
                );
              }).toList(),
              onChanged: (val) => setState(() {
                _patientEmail = val!;
              }),
            );
          }
        });
  }

  void _sendPatient(PatientDao patientDao, UserDao userDao) async {
    final email = userDao.email();
    if (_canSendChart()) {
      final doctor = await Doctor.fromEmail(email!);
      final chart = Chart(
          text: _chartController.text,
          date: DateTime.now(),
          medicalID: doctor.medicalId,
          doctorName: doctor.name);
      final patient = await Patient.fromEmail(_patientEmail);
      patient.addChart(chart);
      patientDao.updatePatient(patient);
      _chartController.clear();
      setState(() {});
    }
  }

  bool _canSendChart() =>
      _chartController.text.length > 0 && _patientEmail != "";

  void logout() async {
    await auth.signOut();
    Navigator.of(context, rootNavigator: true).pop(context);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
