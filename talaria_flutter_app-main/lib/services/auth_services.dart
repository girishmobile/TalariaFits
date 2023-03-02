import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:talaria/constants/fb_collections.dart';
import 'package:talaria/models/user_model.dart';
import 'package:talaria/provider/auth_provider.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/show_message.dart';

abstract class BaseAuth {
  Future<User?> signInWithEmailPassword(String? email, String? password);
  Future<User?> createUserWithEmailPassword(String? email, String? password);
  User? getCurrentUser();
  Future<UserModel?> getUserData(String? email);
  Future<void> signOut();
  Future<void> sendResetPassEmail(String? email);
  Future<void> updateProfile(UserModel? userModel, String email);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User?> createUserWithEmailPassword(
      String? email, String? password) async {
    var provider = Provider.of<AuthProvider>(Get.context!, listen: false);
    var val;
    try {
      var user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email!, password: password!))
          .user;
      try {
        await user?.sendEmailVerification();
        return user;
      } catch (e) {
        provider.stopLoading();
        ShowMessage.inSnackBar(
            title: "Validation Error!",
            message:
                "An error occurred while trying to send email  verification",
            color: AppColors.redColor);
        log("An error occurred while trying to send email  verification");
        log(e.toString());
      }
    } catch (e) {
      provider.stopLoading();
      log("I am Error \n\n\n $e");
      return null;
    }
    return val;
  }

  @override
  User? getCurrentUser() {
    var user = _firebaseAuth.currentUser;
    return user;
  }

  @override
  Future<User?> signInWithEmailPassword(String? email, String? password) async {
    var provider = Provider.of<AuthProvider>(Get.context!, listen: false);
    log("sign in method");
    try {
      var user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email!, password: password!))
          .user;
      if (user!.emailVerified) {
        return user;
      } else {
        provider.stopLoading();
        ShowMessage.inSnackBar(
          title: "Warning",
          message:
              "You haven't verified your email yet, the link has been sent again to your registered email",
          color: AppColors.redColor,
        );
        user.sendEmailVerification();
        FirebaseAuth.instance.signOut();
        return null;
      }
    } catch (e) {
      provider.stopLoading();
      String error = e.toString();
      log("sign in error $e");
      if (error.contains("too-many-requests")) {
        ShowMessage.inSnackBar(
          title: "Try Again Later",
          message:
              "This Device is blocked for some time due to unusual activity. ",
          color: AppColors.redColor,
        );
      } else if (error.contains("wrong-password")) {
        Get.snackbar("Wrong Password", "ENTER CORRECT PASSWORD",
            colorText: AppColors.whiteColor,
            backgroundColor: AppColors.redColor,
            margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.02, horizontal: Get.width * 0.03));
      } else if (error.contains("user-not-found")) {
        Get.snackbar("Wrong Email", "No User found against this email.",
            colorText: AppColors.whiteColor,
            backgroundColor: AppColors.redColor,
            margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.02, horizontal: Get.width * 0.03));
      }
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> sendResetPassEmail(String? email) async {
    FirebaseAuth.instance.sendPasswordResetEmail(email: '$email').then((value) {
      log("success");
    }).catchError((e) {
      String error = e.toString();
      log(error);

      if (error.contains('user-not-found')) {
        ShowMessage.toast(
          msg: 'Email not registered',
        );
      } else {
        log(e.toString());
        ShowMessage.toast(
          msg: e.toString(),
        );
      }
    });
  }

  @override
  Future<void> getLocations() {
    // TODO: implement getLocations
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> getUserData(String? email) async {
    try {
      DocumentSnapshot result = await FBCollections.users.doc(email).get();
      log(result.id);
      UserModel user = UserModel.fromJson(result.data());
      return user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<void> updateProfile(UserModel? userModel, String? email) {
    return FBCollections.users.doc(email).update(userModel!.toJson());
  }
}
