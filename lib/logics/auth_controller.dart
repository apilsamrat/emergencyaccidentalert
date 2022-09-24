// ignore_for_file: use_build_context_synchronously
import 'package:emergencyalert/layouts/home.dart';
import 'package:emergencyalert/layouts/login.dart';
import 'package:emergencyalert/layouts/toaster.dart';
import 'package:emergencyalert/layouts/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;
User? user;
String resultLoginUser = "Welcome";
String resultCreateUser = "success";
UserCredential? userCred;

class AuthUser {
  String _email = "";
  String _password = "";
  late BuildContext _context;
  AuthUser({required email, required password, required BuildContext context}) {
    _email = email;
    _password = password;
    _context = context;

    resultLoginUser = "success";
    resultCreateUser = "success";
  }

  Future<UserCredential?> login() async {
    FirebaseAuth ref = FirebaseAuth.instance;
    try {
      userCred = await ref.signInWithEmailAndPassword(
          email: _email, password: _password);

      if (userCred!.user != null) {
        prefs = await SharedPreferences.getInstance();
        prefs?.setString("email", _email);
        prefs?.setString("password", _password);
        prefs?.setBool("isLoggedinBefore", true);
        if (userCred!.user!.emailVerified == true) {
          Navigator.pushAndRemoveUntil(
              _context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              _context,
              MaterialPageRoute(builder: (context) => const VerifyEmail()),
              (route) => false);
        }
      } else {
        Navigator.pushAndRemoveUntil(
            _context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false);
      }
    } on FirebaseAuthException catch (error) {
      Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);

      AwesomeToaster.showToast(
          context: _context, msg: error.message.toString());
    }
    return userCred;
  }

  Future<String> signup({
    required String fullName,
    required String pswd,
  }) async {
    FirebaseAuth ref = FirebaseAuth.instance;
    FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
    try {
      await ref
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((value) {
        firestoreRef.doc("users/${value.user!.uid}").set({
          "uid": value.user!.uid,
          "email": _email,
          "fullName": fullName,
          "isAccountVerified": false,
        });
      }).then((value) async {
        return await ref.signInWithEmailAndPassword(
            email: _email, password: _password);
      }).then((value) async {
        FirebaseAuth.instance.currentUser!.updateDisplayName(fullName);
        FirebaseAuth.instance.currentUser!.updateEmail(_email);

        if (value.user != null) {
          prefs = await SharedPreferences.getInstance();
          prefs?.setString("email", _email);
          prefs?.setString("password", _password);
          prefs?.setBool("isLoggedinBefore", true);
        }
        AwesomeToaster.showToast(
            context: _context, msg: "Account created successfully");
      });
    } on FirebaseAuthException catch (error) {
      resultCreateUser = error.message.toString();
    }

    if (resultCreateUser != "success") {
      AwesomeToaster.showToast(context: _context, msg: resultCreateUser);
    }
    return resultCreateUser;
  }
}
