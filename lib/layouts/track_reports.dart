import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencyalert/layouts/home.dart';
import 'package:emergencyalert/layouts/toaster.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../resources/colors.dart';

List<dynamic> arrayCaseReportedIndividually = [];
bool _stillLoading = true;
Map<String, dynamic>? _data;

class TrackReportPage extends StatefulWidget {
  const TrackReportPage({super.key});

  @override
  State<TrackReportPage> createState() => _TrackReportPageState();
}

class _TrackReportPageState extends State<TrackReportPage> {
  Future<String> retrieveData({required int index}) async {
    await FirebaseFirestore.instance
        .collection("reports")
        .doc(arrayCaseReportedIndividually[index])
        .get()
        .then((value) {
      _data = value.data();
    });
    return _data!["accidentType"].toString();
  }

  getData() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        var data = value.data();
        arrayCaseReportedIndividually = data!["arrayReportsYet"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (arrayCaseReportedIndividually != []) {
    //   setState(() {
    //     _stillLoading = false;
    //   });
    // } else {
    //   setState(() {
    //     _stillLoading = true;
    //   });
    // }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Cases You Reported"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.topCenter,
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
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                    textAlign: TextAlign.center,
                    "This is only a mockup page for now. Click on the card to go back to the home page.",
                    style: TextStyle(
                        color: lightRed, fontWeight: FontWeight.bold)),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              child: Card(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Car Accident",
                              style: TextStyle(
                                  color: lightRed,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          Image.network(
                            "https://cdn.pixabay.com/photo/2016/04/05/01/49/crash-1308575__340.jpg",
                            width: 100,
                            height: 100,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Divider(
                          color: lightRed,
                          thickness: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Accident severity",
                                style: TextStyle(
                                    color: lightRed,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: Text("Low",
                                style: TextStyle(
                                  color: lightRed,
                                  fontSize: 15,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Accident Type",
                                style: TextStyle(
                                    color: lightRed,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: Text("Car Accident",
                                style: TextStyle(
                                  color: lightRed,
                                  fontSize: 15,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Accident Location",
                                style: TextStyle(
                                    color: lightRed,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: Text(
                                "https://www.google.com/maps/place/Kathmandu,+",
                                style: TextStyle(
                                  color: lightRed,
                                  fontSize: 15,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Accident Date and Time",
                                style: TextStyle(
                                    color: lightRed,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: Text("2022-04-23 12:00",
                                style: TextStyle(
                                  color: lightRed,
                                  fontSize: 15,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Accident Cause",
                                style: TextStyle(
                                    color: lightRed,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: Text("Careless",
                                style: TextStyle(
                                  color: lightRed,
                                  fontSize: 15,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Accident Type",
                                style: TextStyle(
                                    color: lightRed,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: Text("Car Accident",
                                style: TextStyle(
                                  color: lightRed,
                                  fontSize: 15,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text("Current Status",
                                style: TextStyle(
                                    color: lightRed,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text("Verifying",
                                style: TextStyle(
                                  color: lightRed,
                                  fontSize: 15,
                                )),
                          ),
                          Expanded(
                            flex: 1,
                            child: MaterialButton(
                              color: blue,
                              onPressed: () {
                                AwesomeToaster.showToast(
                                    context: context, msg: "View Profile");
                              },
                              child: Text("View Profile",
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 15,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
