import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreenController with ChangeNotifier {
  bool isLoading = false;
  Future onRegistration(
      {required String emailAddress,
      required String password,
      required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      if (credential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User Registered successfully")));

        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("The password provided is too weak.")));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("The account already exists for that email")));
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
