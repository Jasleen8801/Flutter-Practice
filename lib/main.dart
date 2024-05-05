import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_cli/checkuser.dart';
import 'package:flutterfire_cli/firebase_options.dart';
import 'package:flutterfire_cli/email%20auth/loginpage.dart';
import 'package:flutterfire_cli/phone%20auth/phoneauth.dart';
import 'package:flutterfire_cli/showdata.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.roboto(
            fontSize: 30,
          ),
          bodyMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.pacifico(),
        ),
      ),
      // home: CheckUser(),
      // home: PhoneAuth(),
      home: ShowData(),
    );
  }
}