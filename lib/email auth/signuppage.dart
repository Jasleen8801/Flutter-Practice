import 'package:flutter/material.dart';
import 'package:flutterfire_cli/uihelper.dart';
import 'package:flutterfire_cli/email%20auth/loginpage.dart';
import 'package:flutterfire_cli/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signup(String email, String password) async {
    if (email == "" || password == "") {
      UiHelper.CustomAlertBox(context, "Please fill all the fields");
    } else {
      UserCredential? userCredential;
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ).then((value) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Homepage")));
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up Page'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UiHelper.CustomTextField(
                emailController, "Email", Icons.mail, false),
            UiHelper.CustomTextField(
                passwordController, "Password", Icons.lock, true),
            SizedBox(height: 30),
            UiHelper.CustomButton(() {
              signup(emailController.text.toString(),
                  passwordController.text.toString());
            }, "Sign Up"),
          ],
        ));
  }
}
