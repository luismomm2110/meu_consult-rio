import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:meu_consultorio/data/doctor_dao.dart';
import 'package:meu_consultorio/data/patient_dao.dart';
import 'package:meu_consultorio/data/user_dao.dart';
import 'package:meu_consultorio/models/appointment.dart';
import 'package:meu_consultorio/models/doctor.dart';
import 'package:provider/provider.dart';
import '../models/patient.dart';
import '../models/chart.dart';
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
  String _doctorEmail = "";
  DateTime _dueDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    final userDao = Provider.of<UserDao>(context, listen: false);
    final patientDao = Provider.of<PatientDao>(context, listen: false);
    email = userDao.email();
    final doctorDao = DoctorDao();

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
            Row(
              children: [
                Expanded(
                  child: listOfDoctors(doctorDao),
                ),
                SizedBox(width: 70),
                buildDateField(context),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      child: Text("Schedule an appointment"),
                      onPressed: () {
                        if (_doctorEmail != "") {
                          _sendDoctor(doctorDao, userDao);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Check if there's a empty field"),
                            duration: Duration(seconds: 1),
                          ));
                        }
                      }),
                ),
              ],
            ),
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

  StreamBuilder<QuerySnapshot<Object?>> listOfDoctors(DoctorDao doctorDao) {
    return StreamBuilder<QuerySnapshot>(
        stream: doctorDao.getDoctorStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: LinearProgressIndicator());
          } else {
            return DropdownButtonFormField<String>(
              value: null,
              items: snapshot.data!.docs.map<DropdownMenuItem<String>>((data) {
                final doctor = Doctor.fromSnapshot(data);
                return DropdownMenuItem<String>(
                  value: doctor.email,
                  child: Text(doctor.name),
                );
              }).toList(),
              onChanged: (val) => setState(() {
                _doctorEmail = val!;
              }),
            );
          }
        });
  }

  Widget buildDateField(BuildContext context) {
    // 1
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date',
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () async {
                final currentDate = DateTime.now();
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: currentDate,
                  firstDate: currentDate,
                  lastDate: DateTime(currentDate.year + 5),
                );
                setState(() {
                  if (selectedDate != null) {
                    _dueDate = selectedDate;
                  }
                });
              },
            ),
          ],
        ),
        Text('${DateFormat('dd/MM/yyyy').format(_dueDate)}'),
      ],
    );
  }

  void _sendDoctor(DoctorDao doctorDao, UserDao userDao) async {
    final email = userDao.email();
    final patient = await Patient.fromEmail(email!);
    final appointment = Appointment(patientName: patient.name, date: _dueDate);
    final doctor = await Doctor.fromEmail(_doctorEmail);
    doctor.addAppointments(appointment);
    doctorDao.updateDoctor(doctor);
    setState(() {});
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
