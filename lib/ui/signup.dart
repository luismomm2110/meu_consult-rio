import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meu_consultorio/data/doctor_dao.dart';
import 'package:meu_consultorio/data/patient_dao.dart';
import 'package:meu_consultorio/models/doctor.dart';
import 'package:meu_consultorio/models/patient.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  bool isDoctor = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Clinic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Center(
                    child: Text("Create your account"),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(height: 80),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Insert your name',
                      ),
                      autofocus: false,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      controller: _nameController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Name Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(height: 20),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Email Address',
                      ),
                      autofocus: false,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      controller: _emailController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Email Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(), hintText: 'Password'),
                      autofocus: false,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      controller: _passwordController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Password Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(height: 40),
                  Checkbox(
                      value: this.isDoctor,
                      activeColor: Colors.black,
                      onChanged: (bool? value) {
                        setState(() {
                          this.isDoctor = value!;
                        });
                      }),
                  const Text("Are you a doctor?")
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: ElevatedButton(
                        child: const Text('Sign Up'),
                        onPressed: () async {
                          String? registerError = await _doRegister();
                          if (registerError != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(registerError),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        }),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _doRegister() async {
    var errorMessage;

    try {
      await auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      if (isDoctor) {
        _createDoctor();
        Navigator.pushReplacementNamed(context, '/doctor_dashboard');
      } else {
        _createPatient();
        Navigator.pushReplacementNamed(context, "/patient_dashboard");
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          errorMessage = "Invalid Email";
          break;
        case 'weak-password':
          errorMessage = "Weak Password";
          break;
        case "email-already-in-use":
          errorMessage = "Email Already In Use";
          break;
        default:
          errorMessage = "error";
      }
    }

    return errorMessage;
  }

  void _createDoctor() {
    Doctor doctor = Doctor(
        name: _nameController.text,
        email: _emailController.text,
        medicalId: 'CRM' + (Random().nextInt(900000) + 100000).toString());
    DoctorDao doctorDao = DoctorDao();
    doctorDao.saveDoctor(doctor);
  }

  void _createPatient() {
    Patient patient = Patient(
      name: _nameController.text,
      email: _emailController.text,
    );
    PatientDao patientDao = PatientDao();
    patientDao.savePatient(patient);
  }
}
