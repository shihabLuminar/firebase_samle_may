import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreenController with ChangeNotifier {
  bool isLoading = false;
  var pickedImageurl;
  var databseCollection = FirebaseFirestore.instance.collection("courses");

  Future<void> addCourse({
    required String name,
    required String duration,
    required String timing,
    required String uploadedimageurl,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final data = {
        "name": name,
        "timing": timing,
        "duration": duration,
        "imageurl": uploadedimageurl
      };
      await databseCollection.add(data);
    } catch (e) {
      print(e);
    }

    isLoading = false;
    notifyListeners();
  }

  void updateCourse() {}

  Future<void> deleteCourse(var docId) async {
    await databseCollection.doc(docId).delete();
  }

  Future uploadImage() async {
    var uniqueName = DateTime.now().microsecondsSinceEpoch.toString();
    log(uniqueName);
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    // Points to the root reference
    final storageRef = FirebaseStorage.instance.ref();

    // Points to "images"
    Reference? folder = storageRef.child("courses");

    var imagereference = folder.child("$uniqueName.jpg");
    if (pickedFile != null) {
      await imagereference.putFile(File(pickedFile!.path));
      pickedImageurl = await imagereference.getDownloadURL();

      notifyListeners();
    }
  }
}
