import 'package:flutter/material.dart';

class AwesomeToaster {
  static showToast({required BuildContext context, required String msg}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  msg,
                  style: const TextStyle(
                      fontFamily: "vt323", fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      elevation: 0,
    ));
  }

  static showLongToast(
      {required BuildContext context,
      required Duration duration,
      required String msg}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: duration,
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  msg,
                  style: const TextStyle(
                      fontFamily: "vt323", fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      elevation: 0,
    ));
  }
}
