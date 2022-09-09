import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../logics/data_view_logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resources/colors.dart';

class TrackReports extends StatefulWidget {
  const TrackReports({Key? key}) : super(key: key);

  @override
  State<TrackReports> createState() => _TrackReportsState();
}

class _TrackReportsState extends State<TrackReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cases Reported by You")),
      body: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("reports")
                  .where("userId",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: CupertinoActivityIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: ((context, index) {
                          return lister(
                              snap: snapshot.data.docs[index],
                              context: context);
                        })),
                  );
                }
                if (!snapshot.hasData) {
                  return Expanded(
                      child: Center(
                          child: Text(
                    "You have not submitted any reports yet :)",
                    style: TextStyle(
                        fontFamily: "vt323", fontSize: 25, color: red),
                  )));
                }
                return Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget lister({required snap, required BuildContext context}) {
  var data = snap.data();
  return InkWell(
    onTap: () {},
    child: Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(data["accidentType"],
                    style: TextStyle(
                        color: lightRed,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () {},
                  child: InkWell(
                    onTap: () {
                      showImage(context: context, data: data);
                    },
                    child: Image.network(
                      data["imageUrl"].toString(),
                      width: 100,
                      height: 100,
                    ),
                  ),
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
                  child: Text(data["accidentSeverity"].toString(),
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
                  child: Text(data["accidentType"].toString(),
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
                  child: Text(data["accidentLocation"].toString(),
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
                  child: Text(
                      (data["accidentDateandTime"] as Timestamp)
                          .toDate()
                          .toString(),
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
                  child: Text("Current Status",
                      style: TextStyle(
                          color: lightRed,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Text(data["currentStatus"].toString(),
                      style: TextStyle(
                        color: lightRed,
                        fontSize: 15,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
