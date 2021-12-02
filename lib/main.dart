import 'package:flutter/material.dart';
import 'package:meu_consultorio/ui/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../data/chart_dao.dart';
import '../data/user_dao.dart';
import 'ui/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyClinic());
}

class MyClinic extends StatelessWidget {
  const MyClinic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDao>(
          lazy: false,
          create: (_) => UserDao(),
        ),
        Provider<ChartDao>(
          lazy: false,
          create: (_) => ChartDao(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyCLinic',
        theme: ThemeData(primaryColor: Colors.white),
        home: Consumer<UserDao>(
          builder: (context, userDao, child) {
            if (userDao.isLoggedIn()) {
              return const Home();
            } else {
              return const Login();
            }
          },
        ),
      ),
    );
  }
}
