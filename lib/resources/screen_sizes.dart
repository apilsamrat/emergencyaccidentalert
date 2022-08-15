import 'package:flutter/material.dart';

class CreatedSystem {
  BuildContext context;
  CreatedSystem({required this.context});
  double getScreenWidth() {
    return MediaQuery.of(context).size.width;
  }

  bool getIsScreeenWidthBig() {
    return getScreenWidth() > 600 ? true : false;
  }

  bool getIsScreeenWidthReallyBig() {
    return getScreenWidth() > 1000 ? true : false;
  }

  double getPreciseWidth() {
    return getScreenWidth() / 3 * 2;
  }
}
