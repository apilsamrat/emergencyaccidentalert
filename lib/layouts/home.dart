import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencyalert/layouts/drawer.dart';
import 'package:emergencyalert/layouts/profile.dart';
import 'package:emergencyalert/layouts/report.dart';
import 'package:emergencyalert/layouts/toaster.dart';
import 'package:emergencyalert/layouts/track_reports.dart';
import 'package:emergencyalert/layouts/verify.dart';
import 'package:emergencyalert/resources/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../resources/screen_sizes.dart';

bool? _isAccountVerified;
bool? _isVerificationRequestSent;

int caseReported = 0;

PermissionStatus _isLocationPermissionGranted = PermissionStatus.denied;

List<String> dashboardItems = [
  "Report a Case",
  "Track My Reports",
  "My Profile",
  "Help",
];

List<IconData> dashboardIcons = [
  Icons.report_problem,
  Icons.track_changes,
  Icons.person,
  Icons.help,
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Are you sure?"),
              content: const Text("Do you want to exit?"),
              actions: <Widget>[
                TextButton(
                  child: const Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: const Text("Yes"),
                  onPressed: () => SystemNavigator.pop(),
                )
              ],
            )));
  }

  @override
  void initState() {
    super.initState();
    locationPermission();
    getData();
    getVerificationStates();
  }

  getVerificationStates() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        var data = value.data();
        _isAccountVerified = data!['isAccountVerified'];
        _isVerificationRequestSent = data['verificationRequestSent'];
      });
    });
  }

  locationPermission() async {
    _isLocationPermissionGranted = await Location.instance.hasPermission();
    if (_isLocationPermissionGranted == PermissionStatus.denied) {
      _isLocationPermissionGranted =
          await Location.instance.requestPermission();
    } else if (_isLocationPermissionGranted == PermissionStatus.deniedForever) {
      setState(() {
        showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
                content: const Text(
                    "Please enable location permission in settings to use this app"),
                title: const Text("Location Permission Denied Permanetly"),
              );
            }));
      });
    } else if (_isLocationPermissionGranted == PermissionStatus.granted) {
      return;
    }
  }

  void oneSignal() {
    try {
      OneSignal.shared.setAppId("90c58bbe-a1b6-466e-b0e1-1b3b79563bea");

      OneSignal.shared
          .promptUserForPushNotificationPermission()
          .then((accepted) {});
    } catch (e) {
      // print(object)
    }
  }

  getData() async {
    FirebaseFirestore.instance.collection("reports").get().then((value) {
      setState(() {
        caseReported = value.docs.length;
      });
    });
  }

  void showNotVerifiedDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return AlertDialog(
            actions: [
              TextButton(
                child: Text(
                  "VERIFY NOW",
                  style: TextStyle(color: blue),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VerifyIdentityPage()));
                },
              ),
              TextButton(
                child: const Text("OKAY"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Please verify your account to use this feature"),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      "Questions?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(" Contact us at: "),
                    TextButton(
                        onPressed: () {
                          launchUrlString("mailto:me@apilpoudel.com.np",
                              mode: LaunchMode.externalApplication);
                        },
                        child: const Text("me@apilpoudel.com.np"))
                  ],
                ),
              ],
            ),
            title: const Text("Account Not Verified"),
          );
        }));
  }

  void showVerificationInProcessDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return AlertDialog(
            actions: [
              TextButton(
                child: const Text("OKAY"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("We have received your request"),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Please, Provide us at least two business days to verify  your account\n",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "adventPro",
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      "Questions?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(" Contact us at: "),
                    TextButton(
                        onPressed: () {
                          launchUrlString("mailto:me@apilpoudel.com.np",
                              mode: LaunchMode.externalApplication);
                        },
                        child: const Text("me@apilpoudel.com.np"))
                  ],
                ),
              ],
            ),
            title: const Text("Account Not Verified"),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              title: const Text(
                'Emergency Alert',
              ),
            ),
            drawer: const Drawer(
              child: DrawerPage(),
            ),
            body: Center(
              child: Container(
                width: CreatedSystem(context: context).getIsScreeenWidthBig()
                    ? CreatedSystem(context: context).getPreciseWidth()
                    : CreatedSystem(context: context).getScreenWidth(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedFlipCounter(
                                          duration: const Duration(seconds: 2),
                                          value: caseReported,
                                          textStyle: TextStyle(
                                              fontFamily: "vt323",
                                              fontSize: 35,
                                              color: lightRed,
                                              fontWeight: FontWeight.bold)),
                                      Text("Cases Reported Yet",
                                          style: TextStyle(
                                            fontFamily: "vt323",
                                            color: lightRed,
                                            fontSize: 20,
                                          )),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    (_isAccountVerified != null)
                        ? Expanded(
                            child: Container(
                              alignment: Alignment.topCenter,
                              child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                itemCount: 4,
                                itemBuilder: (BuildContext context, int index) {
                                  return MaterialButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      switch (index) {
                                        case 0:
                                          if (_isAccountVerified == true) {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const ReportPage();
                                            }));
                                          } else if (_isVerificationRequestSent ==
                                              true) {
                                            showVerificationInProcessDialog();
                                          } else {
                                            showNotVerifiedDialog();
                                          }
                                          break;
                                        case 1:
                                          if (_isAccountVerified == true) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        const TrackReports())));
                                          } else if (_isVerificationRequestSent ==
                                              true) {
                                            showVerificationInProcessDialog();
                                          } else {
                                            showNotVerifiedDialog();
                                          }

                                          break;
                                        case 2:
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ProfilePage()));
                                          break;
                                        case 3:
                                          AwesomeToaster.showToast(
                                              context: context,
                                              msg: "Not Yet Implemented");
                                          // Navigator.push(context, MaterialPageRoute(
                                          //     builder: (context) => HelpPage()));
                                          break;
                                      }
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        gradient: LinearGradient(
                                          colors: [startBlue, endBlue],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            dashboardIcons[index],
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          Center(
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              dashboardItems[index],
                                              style: const TextStyle(
                                                fontFamily: "vt323",
                                                color: Colors.white,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : const Expanded(
                            child: Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
