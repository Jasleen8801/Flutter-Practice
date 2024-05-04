import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_cli/uihelper.dart';
import 'package:flutterfire_cli/signuppage.dart';
import 'package:flutterfire_cli/homepage.dart';
import 'package:flutterfire_cli/forgotpassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login(String email, String password) async {
    if (email == "" || password == "") {
      UiHelper.CustomAlertBox(context, "Please fill all the fields");
    } else {
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        ).then((value) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: "Homepage")));
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
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
        title: const Text('Login Page'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomTextField(emailController, "Email", Icons.mail, false),
          UiHelper.CustomTextField(passwordController, "Password", Icons.lock, true),
          const SizedBox(height: 30),
          UiHelper.CustomButton(() {
            login(emailController.text.toString(), passwordController.text.toString());
          }, "Login"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             const  Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage())
                  );
                },
                child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPassword())
              );
            },
            child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
            )
          )
        ],
      )
    );
  }
}
