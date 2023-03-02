import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AppUtils {
  static Transition pageTransition = Transition.leftToRightWithFade;
  static Duration transitionDuration = const Duration(milliseconds: 1000);
  static bool isLoading = false;
  static String msgErrorTitle = "Validation Error!";
  static String msgSuccessTitle = "Success";
  static String myFcmToken = "";
  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press again to exit");
      return Future.value(false);
    }
    return exit(0);
  }

  static void hideKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  static Widget circularLoader({double? size, double? lineWidth}) {
    return SpinKitRing(
      color: Colors.blue,
      size: size ?? 20,
      lineWidth: lineWidth ?? 2,
    );
  }

  static bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom != 0.0;
  }
}
