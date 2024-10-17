import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_samle_may/controller/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final Stream<QuerySnapshot> _coursesStream =
      FirebaseFirestore.instance.collection('courses').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          customAlertDialogue(context);
        },
      ),
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
        stream: _coursesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: const Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                    onTap: () {
                      customAlertDialogue(context,
                          isEdit: true,
                          name: data['name'],
                          duration: data['duration']);
                    },
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              context
                                  .read<HomeScreenController>()
                                  .deleteCourse(document.id);
                            },
                            icon: Icon(Icons.delete)),
                        CircleAvatar(
                          backgroundImage: NetworkImage(data['imageurl']),
                        )
                      ],
                    ),
                    trailing: Text(data['timing']),
                    title: Text(data['name']),
                    subtitle: Text(data['duration']),
                  );
                })
                .toList()
                .cast(),
          );
        },
      ),
    );
  }

  Future<dynamic> customAlertDialogue(BuildContext context,
      {bool isEdit = false, String? name, String? duration}) {
    TextEditingController nameController = TextEditingController();
    TextEditingController durationController = TextEditingController();
    TextEditingController timingController = TextEditingController();

    if (isEdit) {
      nameController.text = name!;
      durationController.text = duration!;
      timingController.text = "old name";
    }
    return showDialog(
      context: context,
      builder: (context) => Consumer<HomeScreenController>(
        builder: (context, providerobject, child) => AlertDialog(
          title: Text("Add a course"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  context.read<HomeScreenController>().uploadImage();
                },
                child: CircleAvatar(
                  backgroundImage: providerobject.pickedImageurl != null
                      ? NetworkImage(providerobject.pickedImageurl)
                      : null,
                  child: providerobject.pickedImageurl == null
                      ? Icon(Icons.person)
                      : null,
                  radius: 70,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: "Name", border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: durationController,
                decoration: InputDecoration(
                    hintText: "Duration", border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: timingController,
                decoration: InputDecoration(
                    hintText: "Timing", border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            ElevatedButton(
                onPressed: () {
                  context.read<HomeScreenController>().addCourse(
                        uploadedimageurl: providerobject.pickedImageurl,
                        name: nameController.text,
                        duration: durationController.text,
                        timing: timingController.text,
                      );
                  Navigator.pop(context);
                },
                child: Text("Add")),
          ],
        ),
      ),
    );
  }
}
