import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_samle_may/view/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreenController with ChangeNotifier {
  bool isLoading = false;
  onLogin(
      {required String emailAddress,
      required String password,
      required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      if (credential.user != null) {
        SnackBar(content: Text("User logged in successfully"));

        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => Homescreen(),
        //     ));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No user found for that email.")));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("wrong-password")));
      }
    }
    isLoading = false;
    notifyListeners();
  }
}
