import 'package:firebase_samle_may/controller/login_screen_controller.dart';
import 'package:firebase_samle_may/main.dart';
import 'package:firebase_samle_may/view/registration_screen/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key
  final TextEditingController _emailController =
      TextEditingController(); // Email controller
  final TextEditingController _passwordController =
      TextEditingController(); // Password controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey, // Assigning form key
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Sign in to Your Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),

              // Email input field
              TextFormField(
                controller: _emailController, // Controller for email
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  hintText: "Your Email Address",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xff1a75d2),
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be empty';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                }, // Validation logic
              ),
              SizedBox(height: 20),

              // Password input field
              TextFormField(
                controller: _passwordController, // Controller for password
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  hintText: "Your Password",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xff1a75d2),
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.red.shade400,
                    ),
                  ),
                  suffixIcon: Icon(
                    Icons.visibility_off_rounded,
                    color: Colors.grey,
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                }, // Validation logic
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Icon(
                            Icons.check,
                            size: 10,
                          ),
                        ),
                      ),
                      Text(
                        "Remember me",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  Text(
                    "Forgot password",
                    style: TextStyle(
                      color: Color(0xff1a75d2),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),

              // Sign in button
              context.watch<LoginScreenController>().isLoading
                  ? Center(child: CircularProgressIndicator())
                  : InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<LoginScreenController>().onLogin(
                              emailAddress: _emailController.text,
                              password: _passwordController.text,
                              context: context);
                          // If form is valid, proceed with login
                          // Code to navigate to home screen on successful login
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xff1a75d2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
              Spacer(),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        // Navigate to registration screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color(0xff1a75d2),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
