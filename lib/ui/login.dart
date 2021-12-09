import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meu_consultorio/data/doctor_dao.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

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
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () async {
                          _doLogin();
                        }),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: ElevatedButton(
                        child: const Text(r'Don"t have a account? Sign Up'),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        }),
                  ),
                ],
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _doLogin() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      DoctorDao doctorDao = DoctorDao();
      final isDoctor = await doctorDao.isUserDoctor(_emailController.text);
      if (isDoctor) {
        Navigator.pushReplacementNamed(context, '/doctor_dashboard');
      } else {
        Navigator.pushReplacementNamed(context, "/patient_dashboard");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Password too weak');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
