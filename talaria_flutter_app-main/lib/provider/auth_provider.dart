import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:images_picker/images_picker.dart';
import 'package:provider/provider.dart';
import 'package:talaria/constants/fb_collections.dart';
import 'package:talaria/models/user_model.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/services/auth_services.dart';
import 'package:talaria/ui/auth/login_screen.dart';
import 'package:talaria/ui/dashboard/dashboard_screen.dart';
import 'package:talaria/utils/app_utils.dart';
import 'package:talaria/utils/show_message.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  final BaseAuth _auth = Auth();
  UserModel userData = UserModel();
  File? profileImage;

  //start and stop loading
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  // get profile image function
  Future getProfileImage() async {
    List<Media>? res = await ImagesPicker.pick(
      pickType: PickType.image,
      quality: 1,
      count: 1,
    );
    try {
      if (res != null) {
        profileImage = File(res[0].path);
      }
      if (profileImage != null && res != null) {
        notifyListeners();
        startLoading();
        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/${userData.email}/main_image');
        UploadTask uploadTask = firebaseStorageRef.putFile(File(res[0].path));
        await uploadTask.then((res) async {
          String imageURL = await res.ref.getDownloadURL();
          await FBCollections.users
              .doc(userData.email)
              .update({"profile_image": imageURL});
          userData = (await getUserFromDB(userData.email ?? ""))!;
          stopLoading();
        });
      }
    } catch (e) {
      print(e);
      stopLoading();
    }
  }

  //create new user
  void createUser(
      BuildContext context, UserModel? userModel, String? pass) async {
    try {
      User? user = await _auth.createUserWithEmailPassword(
          userModel!.email!.trim().toLowerCase(), pass);
      if (user != null) {
        log("user is not null");
        if (userModel != null) {
          log("model is not null");
          userModel.id = user.uid;
          await FBCollections.users
              .doc(userModel.email)
              .set(userModel.toJson());
          stopLoading();
          ShowMessage.inSnackBar(
              title: "Congratulations",
              message: "Email verification link has been sent to you email",
              color: Colors.lightGreen);
          logoutUser(context);
        } else {
          log("model is null");
        }
      }
    } catch (e) {
      stopLoading();
      log('something went wrong');
      log(e.toString());
    }
  }

  //user login
  void loginUser(
    BuildContext context,
    String email,
    String pass,
  ) async {
    try {
      User? user = await _auth.signInWithEmailPassword(email, pass);

      log(user!.email ?? ""); // this is null checker

      await FBCollections.users.doc(email).update({"fcm": AppUtils.myFcmToken});
      UserModel? userModel = await _auth.getUserData(user.email);
      if (userModel != null) {
        if (userModel.isBlocked == true) {
          ShowMessage.inSnackBar(
              title: "OOPS!",
              message: "Your account has been blocked by the admin",
              color: Colors.red);
          stopLoading();
          logoutUser(context);
        } else {
          DashboardProvider _dashboardProvider =
              Provider.of<DashboardProvider>(context, listen: false);
          _dashboardProvider.setUserData(userModel);
          userData = userModel;
          notifyListeners();
          stopLoading();
          if (userModel != null) {
            _dashboardProvider.setUserData(userModel);
            userData = userModel;
            notifyListeners();
            Get.offAll(() => const DashboardScreen());
          } else {
            stopLoading();
          }
        }
      }
    } catch (e) {
      stopLoading();
      log(e.toString());
    }
  }

  // sign in with google
  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      var signInWithCredentialValue =
          await FirebaseAuth.instance.signInWithCredential(credential);
      //checking if the user with this email already exists. If so, then we just get their
      //data. Else, we add them to firestore
      var docResult = await FBCollections.users
          .doc(signInWithCredentialValue.user?.email)
          .get();
      if (docResult.exists) {
        userData =
            (await getUserFromDB(signInWithCredentialValue.user!.email!))!;
        notifyListeners();
      } else {
        await FBCollections.users
            .doc(signInWithCredentialValue.user?.email)
            .set(userData.toJson());
        userData =
            (await getUserFromDB(signInWithCredentialValue.user!.email!))!;
        notifyListeners();
      }
      DashboardProvider _dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      _dashboardProvider.setUserData(userData);
      notifyListeners();
      Get.offAll(() => const DashboardScreen());
    } catch (e) {
      print("Google signIn error:- $e");
      stopLoading();
      GoogleSignIn().signOut();
    }
  }

  // get user data
  Future<UserModel?> getUserFromDB(String docId) async {
    startLoading();
    DocumentSnapshot doc = await FBCollections.users.doc(docId).get();
    stopLoading();
    if (!doc.exists) {
      return null;
    }
    UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    log(user.email ?? "");
    return user;
  }

  //user logout
  Future<void> logoutUser(BuildContext context) async {
    startLoading();
    try {
      DashboardProvider _dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      _dashboardProvider.clearAllData();
      userData = UserModel();
      notifyListeners();
      stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      print(e);
      stopLoading();
      log(e.toString());
    }
  }

  //reset password link
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendResetPassEmail(email);
      ShowMessage.inSnackBar(
          title: "Congratulations",
          message:
              "Password changing link sent to your email address. kindly verify your account.",
          color: Colors.lightGreen);
      Navigator.of(Get.context!).pop();
      stopLoading();
    } catch (e) {
      log(e.toString());
      stopLoading();
    }
  }

  //change password
  void changePassword(String? currentPassword, String? newPassword) async {
    startLoading();
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email ?? "", password: currentPassword!);
    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword!).then((_) {
        stopLoading();
        ShowMessage.inSnackBar(
            title: "Congratulations",
            message: "Your password has been changed successfully",
            color: Colors.lightGreen);
        Navigator.of(Get.context!).pop();
      }).catchError((error) {
        stopLoading();
        var er = error.toString();
        log("error:$er");
        if (er.contains("wrong-password")) {
          ShowMessage.toast(msg: "Wrong old Password");
        } else {
          ShowMessage.toast(msg: er);
        }
      });
    }).catchError((err) {
      stopLoading();
      var er = err.toString();
      log(er);
      if (er.contains("wrong-password")) {
        ShowMessage.toast(msg: "Wrong old Password");
      } else {
        ShowMessage.toast(msg: er);
      }
    });
  }
}
