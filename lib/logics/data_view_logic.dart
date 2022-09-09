import 'package:flutter/material.dart';

void showImage({required BuildContext context, required data}) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            child: Hero(
          tag: "dash",
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InteractiveViewer(
                child: Image.network(
                  width: MediaQuery.of(context).size.height / 3 * 2,
                  height: MediaQuery.of(context).size.height / 3 * 2,
                  data["imageUrl"].toString(),
                ),
              ),
              const Text(
                "Pinch to Zoom!",
                style: TextStyle(fontFamily: "vt323", fontSize: 18),
              ),
            ],
          ),
        ));
      });
}
