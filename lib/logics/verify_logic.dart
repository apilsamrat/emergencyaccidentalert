import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencyalert/layouts/toaster.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Verify {
  BuildContext context;
  Verify(this.context);

  Future<void> applyForVerifyMobile({
    required File ppSize,
    required File front,
    required File back,
    required String documentType,
    required String documentNumber,
    required String profession,
  }) async {
    Reference ppRef = FirebaseStorage.instance.ref(
        "users/${FirebaseAuth.instance.currentUser!.uid}/documents/pp.jpg");
    Reference frontRef = FirebaseStorage.instance.ref(
        "users/${FirebaseAuth.instance.currentUser!.uid}/documents/front.jpg");
    Reference backRef = FirebaseStorage.instance.ref(
        "users/${FirebaseAuth.instance.currentUser!.uid}/documents/back.jpg");

    DocumentReference<Map<String, dynamic>> firebaseFirestoreRef =
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("documents")
            .doc(FirebaseAuth.instance.currentUser!.uid);
    try {
      await ppRef.putFile(ppSize);

      await frontRef.putFile(front);

      await backRef.putFile(back);

      String? ppUrl;
      String? frontUrl;
      String? backUrl;

      await ppRef.getDownloadURL().then((value) {
        ppUrl = value;
      });
      await frontRef.getDownloadURL().then((value) {
        frontUrl = value;
      });
      await backRef.getDownloadURL().then((value) {
        backUrl = value;
      });

      await firebaseFirestoreRef.set(
        {
          "pp": ppUrl,
          "front": frontUrl,
          "back": backUrl,
          "documentType": documentType,
          "documentNumber": documentNumber,
          "profession": profession,
        },
      );
    } on FirebaseException catch (error) {
      AwesomeToaster.showToast(context: context, msg: error.message.toString());
    }
  }

  Future<void> applyForVerifyWeb({
    required Uint8List ppSize,
    required Uint8List front,
    required Uint8List back,
    required String documentType,
    required String documentNumber,
    required String profession,
    required String number,
  }) async {
    Reference ppRef = FirebaseStorage.instance.ref(
        "users/${FirebaseAuth.instance.currentUser!.uid}/documents/pp.jpg");
    Reference frontRef = FirebaseStorage.instance.ref(
        "users/${FirebaseAuth.instance.currentUser!.uid}/documents/front.jpg");
    Reference backRef = FirebaseStorage.instance.ref(
        "users/${FirebaseAuth.instance.currentUser!.uid}/documents/back.jpg");

    DocumentReference<Map<String, dynamic>> firebaseFirestoreRef =
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("documents")
            .doc(FirebaseAuth.instance.currentUser!.uid);
    try {
      await ppRef.putData(ppSize);

      await frontRef.putData(front);

      await backRef.putData(back);

      String? ppUrl;
      String? frontUrl;
      String? backUrl;

      await ppRef.getDownloadURL().then((value) {
        ppUrl = value;
      });
      await frontRef.getDownloadURL().then((value) {
        frontUrl = value;
      });
      await backRef.getDownloadURL().then((value) {
        backUrl = value;
      });

      await firebaseFirestoreRef.set(
        {
          "pp": ppUrl,
          "front": frontUrl,
          "back": backUrl,
          "documentType": documentType,
          "documentNumber": documentNumber,
          "profession": profession,
          "mobile": number,
        },
      );
    } on FirebaseException catch (error) {
      AwesomeToaster.showToast(context: context, msg: error.message.toString());
    }
  }
}
