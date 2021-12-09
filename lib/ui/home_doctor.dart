import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:meu_consultorio/data/doctor_dao.dart';
import 'package:meu_consultorio/data/patient_dao.dart';
import 'package:meu_consultorio/data/user_dao.dart';
import 'package:meu_consultorio/models/appointment.dart';
import 'package:meu_consultorio/models/doctor.dart';
import 'package:meu_consultorio/models/patient.dart';
import 'package:provider/provider.dart';
import '../models/chart.dart';
import 'appointment_widget.dart';

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
    final doctorDao = DoctorDao();
    email = userDao.email();

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text(
            "$email",
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(width: 30),
          Text("MyClinic"),
        ]),
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Make an Prescription",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ]),
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
                      decoration: const InputDecoration(
                          hintText: 'Enter new prescription'),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(_canSendChart()
                        ? CupertinoIcons.arrow_right_circle_fill
                        : CupertinoIcons.arrow_right_circle),
                    onPressed: () {
                      if (_canSendChart()) {
                        _sendPatient(patientDao, userDao);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Check if there's a empty field"),
                          duration: Duration(seconds: 1),
                        ));
                      }
                    })
              ],
            ),
            SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Appointments",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ]),
            _getAppointmentList(doctorDao, userDao)
          ],
        ),
      ),
    );
  }

  Widget _getAppointmentList(DoctorDao doctorDao, UserDao userDao) {
    return FutureBuilder<Doctor>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return const Center(child: LinearProgressIndicator());
        return Expanded(
            child: _buildList(context, snapshot.data!.appointments));
      },
      future: _getDoctor(doctorDao, userDao),
    );
  }

  Widget _buildList(BuildContext context, List<Appointment>? appointments) {
    if (appointments == null) {
      return Center(
        child: Text("No appointments with patients"),
      );
    }
    return ListView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20.0),
      children:
          appointments.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Appointment appointment) {
    return AppointmentWidget(
      appointment.date,
      appointment.patientName,
    );
  }

  Future<Doctor> _getDoctor(DoctorDao doctorDao, UserDao userDao) async {
    final email = userDao.email();
    final doctor = await Doctor.fromEmail(email!);
    return doctor;
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
