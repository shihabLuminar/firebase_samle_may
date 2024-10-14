import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_samle_may/controller/login_screen_controller.dart';
import 'package:firebase_samle_may/controller/registration_screen_controller.dart';
import 'package:firebase_samle_may/firebase_options.dart';
import 'package:firebase_samle_may/view/home_screen/home_screen.dart';
import 'package:firebase_samle_may/view/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => RegistrationScreenController()),
        ChangeNotifierProvider(create: (context) => LoginScreenController())
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Homescreen();
              } else {
                return LoginScreen();
              }
            },
          )),
    );
  }
}
