import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:talaria/utils/colors.dart';

Widget Loader() {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: SpinKitSpinningLines(
      color: AppColors.themeColor,
    ),
  );
}
