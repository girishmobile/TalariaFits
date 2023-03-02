import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/utils/colors.dart';

class AppTextStyle {
  static TextStyle comfortaaBold() {
    return GoogleFonts.comfortaa(
        fontSize: 12.sp,
        color: AppColors.goldenColor,
        fontWeight: FontWeight.w700);
  }

  static TextStyle roboto() {
    return GoogleFonts.roboto(
        fontSize: 12.sp,
        color: AppColors.blackColor,
    );
  }

  static TextStyle openSansSemiBold() {
    return GoogleFonts.openSans(
        fontSize: 12.sp,
        color: AppColors.purpleTextColor,);
  }

  static TextStyle openSansPurple() {
    return GoogleFonts.openSans(
        fontSize: 10.sp,
        color: AppColors.purpleTextColor,);
  }
}
