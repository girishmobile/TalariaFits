import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:talaria/models/user_model.dart';
import 'package:talaria/provider/auth_provider.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/services/auth_services.dart';
import 'package:talaria/ui/auth/login_screen.dart';
import 'package:talaria/ui/dashboard/dashboard_screen.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final BaseAuth _auth = Auth();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
    // Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _controller.forward();
    });
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        User? user = _auth.getCurrentUser();
        if (user != null) {
          UserModel? userModel = await _auth.getUserData(user.email);
          if (userModel != null) {
            DashboardProvider dash =
                Provider.of<DashboardProvider>(context, listen: false);
            dash.userData = userModel;
            AuthProvider auth =
                Provider.of<AuthProvider>(context, listen: false);
            auth.userData = userModel;
            Get.offAll(() => const DashboardScreen());
          } else {
            log("user model null");
            Get.offAll(() => const LoginScreen());
          }
        } else {
          Get.offAll(() => const LoginScreen());
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.themeColor,
            AppColors.darkPurple,
          ],
        )),
        child: ScaleTransition(
          scale: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Image.asset(
                AppImages.logo,
                scale: 4,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
