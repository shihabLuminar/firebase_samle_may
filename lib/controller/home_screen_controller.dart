import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeScreenController with ChangeNotifier {
  bool isLoading = false;

  var databseCollection = FirebaseFirestore.instance.collection("courses");

  Future<void> addCourse() async {
    isLoading = true;
    notifyListeners();

    try {
      final data = {"name": "Tokyo", "timing": "Japan", "duration": "6 months"};
      await databseCollection.add(data);
    } catch (e) {
      print(e);
    }

    isLoading = false;
    notifyListeners();
  }

  void updateCourse() {}

  Future<void> deleteCourse(var docId) async {
    final data = {
      "name": "newdaat",
      "timing": "new timing",
      "duration": "6 months"
    };
    await databseCollection.doc(docId).delete();
  }
}
