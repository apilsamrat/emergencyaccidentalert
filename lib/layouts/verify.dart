import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencyalert/layouts/toaster.dart';
import 'package:emergencyalert/logics/filepicker.dart';
import 'package:emergencyalert/logics/send_email.dart';
import 'package:emergencyalert/logics/verify_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool _isUploadingEnabled = true;

Uint8List? _ppSizePhotoWeb;
Uint8List? _documentFrontWeb;
Uint8List? _documentBackWeb;

File? _ppSizePhotoMobile;
File? _documentFrontMobile;
File? _documentBackMobile;

TextEditingController _documentTypeController = TextEditingController();
TextEditingController _documentNumberController = TextEditingController();
TextEditingController _proffessionController = TextEditingController();

class VerifyIdentityPage extends StatefulWidget {
  const VerifyIdentityPage({super.key});

  @override
  State<VerifyIdentityPage> createState() => _VerifyIdentityPageState();
}

class _VerifyIdentityPageState extends State<VerifyIdentityPage> {
  @override
  Widget build(BuildContext context) {
    String userName = FirebaseAuth.instance.currentUser!.displayName.toString();
    String message =
        "Hi, I am ${FirebaseAuth.instance.currentUser!.displayName} and I am requesting you to verify my identity on Emergency Alert App.\n\nMy Identity is as follows:\n userName: $userName \n email: ${FirebaseAuth.instance.currentUser!.email} \n uid: ${FirebaseAuth.instance.currentUser!.uid}\n\nPlease verify my identity and send me a message when you are done.\n\nThanks!";
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Verify Identity'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Card(
                child: ListTile(
                  leading: Icon(Icons.verified_user),
                  title: Text('Verify Identity'),
                  subtitle: Text('Verify your identity to continue'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("All fields are required",
                    style: TextStyle(color: Colors.red)),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            "Passport Size Photo",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: kIsWeb && _ppSizePhotoWeb != null
                            ? Image.memory(
                                _ppSizePhotoWeb!,
                                height: 150,
                                width: 150,
                              )
                            : !kIsWeb && _ppSizePhotoMobile != null
                                ? Image.file(
                                    _ppSizePhotoMobile!,
                                    height: 150,
                                    width: 150,
                                  )
                                : const SizedBox(height: 150),
                      ),
                      MaterialButton(
                          onPressed: () async {
                            if (kIsWeb) {
                              _ppSizePhotoWeb = await PickFile().pickImageWeb();
                              setState(() {
                                _ppSizePhotoWeb;
                              });
                            } else {
                              _ppSizePhotoMobile =
                                  await PickFile().pickImageMobile();
                              setState(() {
                                _ppSizePhotoMobile;
                              });
                            }
                          },
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text("Upload Photo",
                              style: TextStyle(color: Colors.white))),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                "Document Photos",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "Front",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: kIsWeb && _documentFrontWeb != null
                                    ? Image.memory(
                                        _documentFrontWeb!,
                                        height: 150,
                                        width: 150,
                                      )
                                    : !kIsWeb && _documentFrontMobile != null
                                        ? Image.file(
                                            _documentFrontMobile!,
                                            height: 150,
                                            width: 150,
                                          )
                                        : const SizedBox(height: 150),
                              ),
                            ],
                          ),
                          MaterialButton(
                              onPressed: () async {
                                if (kIsWeb) {
                                  _documentFrontWeb =
                                      await PickFile().pickImageWeb();
                                  setState(() {
                                    _documentFrontWeb;
                                  });
                                } else {
                                  _documentFrontMobile =
                                      await PickFile().pickImageMobile();
                                  setState(() {
                                    _documentFrontMobile;
                                  });
                                }
                              },
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Text("Upload Photo",
                                  style: TextStyle(color: Colors.white))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          const Text(
                            "Back",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: kIsWeb && _documentBackWeb != null
                                ? Image.memory(
                                    _documentBackWeb!,
                                    height: 150,
                                    width: 150,
                                  )
                                : !kIsWeb && _documentBackMobile != null
                                    ? Image.file(
                                        _documentBackMobile!,
                                        height: 150,
                                        width: 150,
                                      )
                                    : const SizedBox(height: 150),
                          ),
                          MaterialButton(
                              onPressed: () async {
                                if (kIsWeb) {
                                  _documentBackWeb =
                                      await PickFile().pickImageWeb();
                                  setState(() {
                                    _documentBackWeb;
                                  });
                                } else {
                                  _documentBackMobile =
                                      await PickFile().pickImageMobile();
                                  setState(() {
                                    _documentBackMobile;
                                  });
                                }
                              },
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Text("Upload Photo",
                                  style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            "Document and User Details",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _documentTypeController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Document Type eg. Passport, Citizenship",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _isUploadingEnabled = true;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _documentNumberController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Document Number",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _isUploadingEnabled = true;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _proffessionController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Your Proffession",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _isUploadingEnabled = true;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: MaterialButton(
                    onPressed: () {
                      if (kIsWeb) {
                        if (_ppSizePhotoWeb == null ||
                            _documentFrontWeb == null ||
                            _documentBackWeb == null ||
                            _proffessionController.text == "" ||
                            _documentNumberController.text == "" ||
                            _documentTypeController.text == "") {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Error"),
                              content: const Text("Please Fill All Fields"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OKAY"),
                                ),
                              ],
                            ),
                          );
                        } else {
                          if (_isUploadingEnabled) {
                            AwesomeToaster.showToast(
                                context: context,
                                msg: "Uploading Please Wait....");
                            showDialog(
                                context: context,
                                useRootNavigator: false,
                                barrierDismissible: false,
                                builder: ((context) {
                                  _isUploadingEnabled = false;

                                  Future<void> proceed() async {
                                    await Verify(context)
                                        .applyForVerifyWeb(
                                            ppSize: _ppSizePhotoWeb!,
                                            front: _documentFrontWeb!,
                                            back: _documentBackWeb!,
                                            documentType:
                                                _documentTypeController.text,
                                            documentNumber:
                                                _documentNumberController.text,
                                            profession:
                                                _proffessionController.text)
                                        .then((value) async {
                                      FirebaseFirestore.instance
                                          .doc(
                                              "users/${FirebaseAuth.instance.currentUser!.uid}/")
                                          .update({
                                        "verificationRequestSent": true,
                                      });
                                      await SendEmail(
                                              userName: userName,
                                              message: message)
                                          .forVerification();
                                      Navigator.pop(context);
                                      AwesomeToaster.showLongToast(
                                          context: context,
                                          duration: const Duration(seconds: 8),
                                          msg:
                                              "Please Wait For About 2 Business Days While We Verify Your Document");
                                    });
                                  }

                                  proceed();
                                  return const AlertDialog(
                                    title: Text("Uploading"),
                                    content: CupertinoActivityIndicator(),
                                  );
                                }));
                          }
                        }
                      } else {
                        if (_ppSizePhotoMobile == null ||
                            _documentFrontMobile == null ||
                            _documentBackMobile == null ||
                            _proffessionController.text == "" ||
                            _documentNumberController.text == "" ||
                            _documentTypeController.text == "") {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: const Text("Please Fill All Fields"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OKAY"),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          if (_isUploadingEnabled) {
                            AwesomeToaster.showToast(
                                context: context,
                                msg: "Uploading Please Wait....");
                            showDialog(
                                useRootNavigator: false,
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  Future<void> proceed() async {
                                    _isUploadingEnabled = false;
                                    await Verify(context)
                                        .applyForVerifyMobile(
                                            ppSize: _ppSizePhotoMobile!,
                                            front: _documentFrontMobile!,
                                            back: _documentBackMobile!,
                                            documentType:
                                                _documentTypeController.text,
                                            documentNumber:
                                                _documentNumberController.text,
                                            profession:
                                                _proffessionController.text)
                                        .then((value) async {
                                      FirebaseFirestore.instance
                                          .doc(
                                              "users/${FirebaseAuth.instance.currentUser!.uid}/")
                                          .update({
                                        "verificationRequestSent": true,
                                      });
                                      await SendEmail(
                                              userName: userName,
                                              message: message)
                                          .forVerification();
                                      Navigator.pop(context);
                                      AwesomeToaster.showLongToast(
                                          context: context,
                                          duration: const Duration(seconds: 8),
                                          msg:
                                              "Please Wait About 2 Business Days While We Verify Your Document");
                                    });
                                  }

                                  proceed();
                                  return const AlertDialog(
                                    content: CupertinoActivityIndicator(),
                                  );
                                });
                          }
                        }
                      }
                    },
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text("Submit For Approval",
                        style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
