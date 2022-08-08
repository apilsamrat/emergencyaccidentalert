import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencyalert/layouts/home.dart';
import 'package:emergencyalert/layouts/login.dart';
import 'package:emergencyalert/layouts/profile.dart';
import 'package:emergencyalert/layouts/toaster.dart';
import 'package:emergencyalert/layouts/verify.dart';
import 'package:emergencyalert/resources/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

User? user;

String userName = "Apil Samrat Poudel";
String accountStatus = "";
bool isAccountVerified = false;
String email = "";
String? photoUrl;
String displayName = "Unknown";
int _selectedIndex = 0;

bool isLoading = true;

bool isVerificationRequestSent = false;
List<String> drawerItems = [
  "Home",
  "Profile",
  "Settings",
  "About",
  "Help",
  "Logout",
];

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;

    initialize();
  }

  Future<void> initialize() async {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
      userName = user?.displayName ?? "Unknown";
      photoUrl = user!.photoURL.toString();
    });
    await FirebaseFirestore.instance
        .doc("users/${FirebaseAuth.instance.currentUser!.uid}")
        .get()
        .then((value) {
      var data = value.data();
      setState(() {
        isVerificationRequestSent = data!["verificationRequestSent"] ?? false;
        isAccountVerified = data["isAccountVerified"] ?? false;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      isAccountVerified
          ? accountStatus = "Verified"
          : isVerificationRequestSent
              ? accountStatus = "Verification in Process"
              : accountStatus = "Not Verified";
    });
    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => const HomePage())),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => const ProfilePage())),
          );
          break;
        case 2:
          AwesomeToaster.showToast(
              context: context, msg: "Settings | Coming Soon");
          break;
        case 3:
          AwesomeToaster.showToast(
              context: context, msg: "About | Coming Soon");
          break;

        case 4:
          AwesomeToaster.showToast(context: context, msg: "Help | Coming Soon");
          break;

        case 5:
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        "No",
                        style: TextStyle(color: blue),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text("Yes"),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const LoginPage())),
                        );
                      },
                    ),
                  ],
                );
              });
          break;
        default:
      }
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      color: veryLightGrey,
      child: Column(
        children: [
          Card(
            child: Container(
              padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
              child: Column(
                children: [
                  CircleAvatar(
                      radius: 50,
                      foregroundImage: NetworkImage(photoUrl!),
                      child: const CupertinoActivityIndicator(
                        color: Colors.white,
                        radius: 10,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                            fontFamily: "adventPro",
                            color: isAccountVerified ? Colors.blue : Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      isAccountVerified
                          ? const Icon(
                              CupertinoIcons.checkmark_circle_fill,
                              color: Colors.blue,
                            )
                          : const Icon(
                              CupertinoIcons.xmark_circle_fill,
                              color: Colors.red,
                            ),
                    ],
                  ),
                  !isLoading
                      ? Column(
                          children: [
                            Text(
                              accountStatus,
                              style: TextStyle(
                                  fontFamily: "adventPro",
                                  color: isAccountVerified
                                      ? Colors.blue
                                      : Colors.red,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            if (!isAccountVerified)
                              Column(
                                children: [
                                  const SizedBox(height: 20),
                                  !isVerificationRequestSent
                                      ? Text(
                                          "Please, verify your account to use the app properly.\n",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "adventPro",
                                              color: isAccountVerified
                                                  ? Colors.blue
                                                  : Colors.red,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const Text(
                                          "Please, Provide us at least two business days to verify  your account\n",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "adventPro",
                                              color: Colors.blue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                  !isVerificationRequestSent
                                      ? TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const VerifyIdentityPage()));
                                          },
                                          style: ButtonStyle(
                                              minimumSize:
                                                  MaterialStateProperty.all(
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
                                                "Verify  ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Icon(
                                                CupertinoIcons
                                                    .arrow_right_circle_fill,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                          ],
                        )
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CupertinoActivityIndicator(
                            radius: 10,
                            color: Colors.blue,
                          ),
                        ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              dragStartBehavior: DragStartBehavior.down,
              shrinkWrap: true,
              itemCount: drawerItems.length,
              itemBuilder: (BuildContext context, int index) {
                bool isSelected = (index == _selectedIndex);
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              isSelected ? Colors.blue : Colors.white),
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 50))),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onItemTapped(index);
                      },
                      child: Text(
                        drawerItems[index],
                        style: TextStyle(
                            fontFamily: "balloo2",
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
