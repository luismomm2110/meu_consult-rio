import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_consultorio/data/patient_dao.dart';
import 'package:meu_consultorio/data/user_dao.dart';
import 'package:provider/provider.dart';

import '../models/patient.dart';
import '../models/chart.dart';
import '../data/chart_dao.dart';
import 'chart_widget.dart';

class HomePatient extends StatefulWidget {
  const HomePatient({Key? key}) : super(key: key);

  @override
  HomePatientState createState() => HomePatientState();
}

class HomePatientState extends State<HomePatient> {
  final ScrollController _scrollController = ScrollController();
  final auth = FirebaseAuth.instance;
  String? email;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    final userDao = Provider.of<UserDao>(context, listen: false);
    final patientDao = Provider.of<PatientDao>(context, listen: false);
    email = userDao.email();

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
            _getChartList(patientDao, userDao),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getChartList(PatientDao patientDao, UserDao userDao) {
    return FutureBuilder<Patient>(
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: LinearProgressIndicator());
        return Expanded(child: _buildList(context, snapshot.data!.charts));
      },
      future: _getPatient(patientDao, userDao),
    );
  }

  Future<Patient> _getPatient(PatientDao patientDao, UserDao userDao) async {
    final email = userDao.email();
    final patient = await Patient.fromEmail(email!);
    return patient;
  }

  Widget _buildList(BuildContext context, List<Chart>? charts) {
    if (charts == null) {
      return Center(
        child: Text("No recipes"),
      );
    }
    return ListView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20.0),
      children: charts.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Chart chart) {
    return ChartWidget(
      chart.text,
      chart.date,
      chart.doctorName,
      chart.medicalID,
    );
  }

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
