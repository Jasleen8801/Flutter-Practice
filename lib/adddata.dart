import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  addData(String title, String desc) async {
    if (title.isEmpty || desc.isEmpty) {
      log("Title or Description is empty");
    } else {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(title)
          .set({
            "title": title,
            "description": desc,
          })
          .then((value) => log("Data Added"))
          .catchError((error) => log("Failed to add data: $error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Data"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter Title",
                  suffixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: descController,
                decoration: InputDecoration(
                  hintText: "Enter Description",
                  suffixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                addData(titleController.text, descController.text);
              },
              child: const Text("Add Data"),
            ),
          ],
        ));
  }
}
