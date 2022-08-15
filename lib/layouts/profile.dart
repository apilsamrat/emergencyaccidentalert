import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencyalert/resources/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resources/screen_sizes.dart';

bool _isEditProfile = false;

String? pp;
String? front;
String? back;
String? documentType;
String? documentNumber;
String? profession;

bool isLoading = true;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    FirebaseFirestore.instance
        .doc(
            "users/${FirebaseAuth.instance.currentUser!.uid}/documents/${FirebaseAuth.instance.currentUser!.uid}")
        .get()
        .then((value) {
      var data = value.data();
      setState(() {
        pp = data!["pp"];
        front = data["front"];
        back = data["back"];
        documentType = data["documentType"];
        documentNumber = data["documentNumber"];
        profession = data["profession"];
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_isEditProfile) {
          setState(() {
            _isEditProfile = false;
          });
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: !_isEditProfile
            ? Center(
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    width:
                        CreatedSystem(context: context).getIsScreeenWidthBig()
                            ? CreatedSystem(context: context).getPreciseWidth()
                            : CreatedSystem(context: context).getScreenWidth(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  minRadius: 50,
                                  maxRadius: 150,
                                  foregroundImage: NetworkImage(
                                    FirebaseAuth.instance.currentUser!.photoURL
                                        .toString(),
                                  ),
                                  child: ClipOval(
                                    child: CupertinoActivityIndicator(
                                      radius: 20,
                                      color: white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                    FirebaseAuth.instance.currentUser!
                                            .displayName ??
                                        'Unknown',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: red,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      FirebaseAuth
                                              .instance.currentUser!.email ??
                                          'Unknown',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 15,
                                      )),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditProfile = true;
                                      });
                                    },
                                    style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(
                                            const Size(125, 40)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Edit Profile  ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          CupertinoIcons
                                              .arrow_right_circle_fill,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        !isLoading
                            ? Card(
                                elevation: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(children: [
                                    const Text("Your Legal Profile",
                                        style: TextStyle(
                                            fontFamily: "vt323",
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 18),
                                    Row(
                                      children: [
                                        Text("Document Type: $documentType",
                                            style: const TextStyle(
                                              fontFamily: "vt323",
                                              fontSize: 20,
                                            ))
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text("Document Number: $documentNumber",
                                            style: const TextStyle(
                                              fontFamily: "vt323",
                                              fontSize: 20,
                                            ))
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text("Profession: $profession",
                                            style: const TextStyle(
                                              fontFamily: "vt323",
                                              fontSize: 20,
                                            ))
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 5),
                                      child: Row(
                                        children: const [
                                          Text("Front of Document:",
                                              style: TextStyle(
                                                fontFamily: "vt323",
                                                fontSize: 20,
                                              ))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                      child: Image.network(
                                        front ?? "",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 5),
                                      child: Row(
                                        children: const [
                                          Text("Back of Document:",
                                              style: TextStyle(
                                                fontFamily: "vt323",
                                                fontSize: 20,
                                              ))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                      child: Image.network(
                                        back ?? "",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 5),
                                      child: Row(
                                        children: const [
                                          Text("Profile Picture:",
                                              style: TextStyle(
                                                fontFamily: "vt323",
                                                fontSize: 20,
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                      child: Image.network(
                                        pp ?? "",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ]),
                                ),
                              )
                            : SizedBox(
                                height: 200,
                                child: CupertinoActivityIndicator(
                                  radius: 20,
                                  color: blue,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              )
            : const EditProfile(),
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Edit Profile',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
