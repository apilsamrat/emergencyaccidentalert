import 'dart:io';

import 'package:emergencyalert/layouts/toaster.dart';
import 'package:emergencyalert/logics/filepicker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _documentNumberController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Document Number",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _proffessionController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Your Proffession",
                          border: OutlineInputBorder(),
                        ),
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
                          AwesomeToaster.showToast(
                              context: context,
                              msg:
                                  "Success on Web || User has Uploaded photos and details");
                          // TODO: Implement Upload to Firebase and Navigate to Home Page
                          // TODO: This is web only code
                          // ToDo: This will run when user inserts all the details and clicks on submit button
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
                          AwesomeToaster.showToast(
                              context: context,
                              msg:
                                  "Success on Mobile || User has Uploaded photos and details");
                          // TODO: Mobile code
                          // TODO: This is for mobile only code
                          // ToDo: This will run when user inserts all the details and clicks on submit button
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
