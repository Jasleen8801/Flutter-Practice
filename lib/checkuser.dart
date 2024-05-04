import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_cli/homepage.dart';
import 'package:flutterfire_cli/loginpage.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({Key? key}) : super(key: key);

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  Future<Widget> checkUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      return MyHomePage(title: "HomeScreen");
    } else {
      return const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: checkUser(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasError)
            return Text('Error: ${snapshot.error}');
          else
            return snapshot.data!;  // snapshot.data 100% contains a non-null value.
        }
      },
    );
  }
}