import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/utils/colors.dart';

class ShowMessage {
  static void toast({String? msg}) {
    Fluttertoast.showToast(
        msg: msg!,
        fontSize: 12.sp,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  static void inSnackBar({String? title, String? message, Color? color}) {
    Get.snackbar(title!, message!,
        backgroundColor: color, colorText: AppColors.whiteColor);
  }
}
