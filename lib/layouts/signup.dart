// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencyalert/layouts/home.dart';
import 'package:emergencyalert/resources/colors.dart';
import 'package:emergencyalert/layouts/login.dart';
import 'package:emergencyalert/logics/auth_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'verify_email.dart';

TextEditingController _emailPhone = TextEditingController();
TextEditingController _fullName = TextEditingController();
TextEditingController _password = TextEditingController();

bool _enableSignUp = true;

File? _profileImage;
Uint8List? _profileImageWeb;

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    void signup() async {
      _enableSignUp = false;
      String result = await AuthUser(
              email: _emailPhone.text,
              password: _password.text,
              context: context)
          .signup(
        fullName: _fullName.text,
        pswd: _password.text,
      );
      if (result == "success") {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        if (_profileImage != null || _profileImageWeb != null) {
          var ref = FirebaseStorage.instance
              .ref("users/$uid/profiles/profilePhoto.jpg");
          if (kIsWeb) {
            await ref.putData(_profileImageWeb!).whenComplete(() {
              ref.getDownloadURL().then((url) {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .update({"photoUrl": url});
                FirebaseAuth.instance.currentUser!.updatePhotoURL(url);
              });
            });
          } else {
            await ref.putFile(_profileImage!).whenComplete(() {
              ref.getDownloadURL().then((url) {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .update({"photoUrl": url});
                FirebaseAuth.instance.currentUser!.updatePhotoURL(url);
              });
            });
          }
        } else {
          FirebaseFirestore.instance
              .doc("users/${FirebaseAuth.instance.currentUser!.uid}")
              .update({"profilePhoto": "null"});
        }
        if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const VerifyEmail()));
        }
      } else {}
    }

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/street-signs.png",
                                width: 150,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Emergency Accident Alert",
                                style: TextStyle(
                                  fontFamily: "adventpro",
                                  fontSize: 20,
                                  color: lightRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: const [
                                  Text(
                                    "Please create a new account",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: "vt323", fontSize: 20),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _emailPhone,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    label: const Text("Email"),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0))),
                                onChanged: (value) {
                                  _enableSignUp = true;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: _fullName,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    label: const Text("Full Name"),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0))),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                controller: _password,
                                decoration: InputDecoration(
                                    label: const Text("Password"),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0))),
                              ),
                              const SizedBox(height: 20),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: kIsWeb
                                    ? _profileImageWeb != null
                                        ? Image.memory(
                                            _profileImageWeb!,
                                            height: 50,
                                            width: 50,
                                          )
                                        : const SizedBox(height: 20)
                                    : _profileImage != null
                                        ? Image.file(
                                            _profileImage!,
                                            height: 50,
                                            width: 50,
                                          )
                                        : const SizedBox(height: 20),
                              ),
                              TextButton.icon(
                                  onPressed: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      allowMultiple: false,
                                      type: FileType.image,
                                      dialogTitle: "Select Profile Photo",
                                    );
                                    if (result != null) {
                                      setState(() {
                                        if (kIsWeb) {
                                          _profileImageWeb = result
                                                  .files.first.bytes ??
                                              File("/assets/images/person.png")
                                                  .readAsBytesSync();
                                        } else {
                                          _profileImage = File(
                                              result.files.first.path ??
                                                  "/assets/images/person.png");
                                        }
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.person),
                                  label: const Text("Select an Profile Image")),
                              const SizedBox(
                                height: 20,
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (_enableSignUp) {
                                    _enableSignUp = false;
                                    _emailPhone.text =
                                        _emailPhone.text.replaceAll(" ", "");

                                    if (_emailPhone.text.isEmpty ||
                                        _fullName.text.isEmpty ||
                                        _password.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Please fillup the required details")));
                                    } else if (_profileImage == null &&
                                        _profileImageWeb == null) {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("OOPS!"),
                                              content: const Text(
                                                  "Your profile image will be set to default image."),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _enableSignUp = true;
                                                    },
                                                    child: const Text("Wait")),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      signup();
                                                    },
                                                    child: const Text("OK"))
                                              ],
                                            );
                                          });
                                    } else {
                                      signup();
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(double.infinity, 60)),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue)),
                                child: const Text(
                                  "Sign up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text("OR",
                                  style: TextStyle(color: Colors.grey)),
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.facebook,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const HomePage())),
                                      (route) => false);
                                },
                                label: const Text(
                                  "Login with Facebook",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(double.infinity, 60)),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 400,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child:
                              Wrap(alignment: WrapAlignment.center, children: [
                            const Text("Already have an account?  "),
                            TextButton(
                                style: ButtonStyle(
                                    alignment: Alignment.topCenter,
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero)),
                                child: const Text("Login",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.blue)),
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                }),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
