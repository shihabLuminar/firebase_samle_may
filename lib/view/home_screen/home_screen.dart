import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_samle_may/controller/home_screen_controller.dart';
import 'package:firebase_samle_may/main.dart';
import 'package:flutter/material.dart';
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
          context.read<HomeScreenController>().addCourse();
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
                    leading: IconButton(
                        onPressed: () {
                          context
                              .read<HomeScreenController>()
                              .deleteCourse(document.id);
                        },
                        icon: Icon(Icons.delete)),
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
}
