import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String finalresult = "Success";

List<dynamic> arrayReportsYet = [];
String imageUrl = "https://i.im.ge/2022/08/15/OFwcd4.xxx047-512.webp";

String oneSignalAppId = "90c58bbe-a1b6-466e-b0e1-1b3b79563bea";
String notifyUrl = "https://onesignal.com/api/v1/notifications";
String oneSignalapiKey = "NGQyYjFjYTctMDRmMi00MDQ2LTk0ODktNDFlYTRhNmU0ODIz";
String alertMessage =
    "A NEW CASE HAS BEEN REPORTED. PLEASE OPEN THE APP TO VIEW THE DETAILS";

class ReportAccident {
  late BuildContext context;
  ReportAccident({required this.context});

  Future<String> submit({
    required String accidentLocation,
    required String accidentDateandTime,
    required String accidentSeverity,
    required String accidentType,
    File? imageFileAndroid,
    Uint8List? imageDataWeb,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var data = value.data();
      arrayReportsYet = data!["arrayReportsYet"] ?? [];
    });

    await FirebaseFirestore.instance.collection("reports").add({
      "accidentSeverity": accidentSeverity,
      "accidentType": accidentType,
      "accidentLocation": accidentLocation,
      "accidentDateandTime": DateTime.parse(accidentDateandTime),
      "userId": FirebaseAuth.instance.currentUser!.uid,
    }).then((value) async {
      arrayReportsYet.add(value.id);
      var refTask =
          FirebaseStorage.instance.ref("reports/${value.id}/image.jpg");
      if (kIsWeb) {
        await refTask.putData(imageDataWeb!);
      } else {
        await refTask.putFile(imageFileAndroid!);
      }

      imageUrl = await refTask.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("reports")
          .doc(value.id)
          .update({
        "imageUrl": imageUrl,
      });
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "arrayReportsYet": arrayReportsYet,
      });

      await http.post(
        Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Basic $oneSignalapiKey",
        },
        body: jsonEncode({
          "app_id": "90c58bbe-a1b6-466e-b0e1-1b3b79563bea",
          "included_segments": ["Subscribed Users"],
          "data": {"foo": "bar"},
          "big_picture": imageUrl,
          "large_icon": imageUrl,
          "headings": {"en": "ALERT"},
          "contents": {
            "en":
                "NEW CASE ALERT OF ${accidentType.toString()} HAS BEEN REPORTED. TAP TO VIEW THE DETAILS"
          }
        }),
      );
    });
    return finalresult;
  } //submit
} //class
