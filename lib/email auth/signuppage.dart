import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutterfire_cli/uihelper.dart';
import 'package:flutterfire_cli/email%20auth/loginpage.dart';
import 'package:flutterfire_cli/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? pickedImage;

  signup(String email, String password) async {
    if (email == "" || password == "") {
      UiHelper.CustomAlertBox(context, "Please fill all the fields");
    } else {
      UserCredential? userCredential;
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((value) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(title: "Homepage")));
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

  signup2(String email, String password) async {
    if (email == "" && password == "" && pickedImage == null) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Enter Required Fields"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"))
              ],
            );
          });
    } else {
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((value) {
          uploadData();
        });
      } catch (e) {
        log(e.toString());
      }
    }
  }

  uploadData() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("profileImages")
          .child(emailController.text.toString())
          .putFile(pickedImage!);
      TaskSnapshot taskSnapshot = await ref;
      final url = await taskSnapshot.ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection("Users")
          .doc(emailController.text.toString())
          .set({"Email": emailController.text.toString(), "Image": url}).then(
              (value) {
        log("User Added Successfully");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(title: "Homepage")));
      });
    } on FirebaseException catch (e) {
      log(e.toString());
    }
  }

  showAlertBox() {
    return AlertDialog(
        title: Text("Pick Image From"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                pickImage(ImageSource.camera);
              },
              leading: Icon(Icons.camera_alt),
              title: Text("Camera"),
            ),
            ListTile(
              onTap: () {
                pickImage(ImageSource.gallery);
              },
              leading: Icon(Icons.image),
              title: Text("Gallery"),
            ),
          ],
        ));
  }

  pickImage(ImageSource imageSource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
    } catch (e) {
      log(e.toString());
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
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return showAlertBox();
                      });
                },
                child: pickedImage != null
                    ? CircleAvatar(
                        radius: 80,
                        backgroundImage: FileImage(pickedImage!),
                      )
                    : CircleAvatar(
                        radius: 80,
                        child: Icon(Icons.add_a_photo),
                      )),
            UiHelper.CustomTextField(
                emailController, "Email", Icons.mail, false),
            UiHelper.CustomTextField(
                passwordController, "Password", Icons.lock, true),
            const SizedBox(height: 30),
            // UiHelper.CustomButton(() {
            //   signup(emailController.text.toString(),
            //       passwordController.text.toString());
            // }, "Sign Up"),
            UiHelper.CustomButton(() {
              signup2(emailController.text.toString(),
                  passwordController.text.toString());
            }, "Sign Up"),
          ],
        ));
  }
}
