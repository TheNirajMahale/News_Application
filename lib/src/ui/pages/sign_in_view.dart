import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_flutter/src/utils/app_routes.dart';

class SignInView extends StatefulWidget {
  const SignInView({
    super.key,
  });

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void onSignUpButtonPressed() {
    if (validateInput()) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then(
        (value) {
          Navigator.pushAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          );
        },
        onError: (e) {
          if (e is FirebaseAuthException) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message ?? "Something went wrong!!")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete the input form!!")),
      );
    }
  }

  void onSignInButtonPressed() {
    if (validateInput()) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then(
        (value) {
          Navigator.pushAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          );
        },
        onError: (e) {
          if (e is FirebaseAuthException) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message ?? "Something went wrong!!")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete the input form!!")),
      );
    }
  }

  bool validateInput() {
    if (emailController.text.isEmpty) {
      return false;
    } else if (passwordController.text.isEmpty) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      icon: Icon(Icons.email),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: "Password",
                      icon: Icon(Icons.password),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: FilledButton(
                          onPressed: onSignUpButtonPressed,
                          child: Text("Sign Up"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: FilledButton.tonal(
                          onPressed: onSignInButtonPressed,
                          child: Text("Sign In"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
