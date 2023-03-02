import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/models/user_model.dart';
import 'package:talaria/provider/auth_provider.dart';
import 'package:talaria/ui/auth/login_screen.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/images.dart';
import 'package:talaria/utils/loader.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/utils/validation.dart';
import 'package:talaria/widgets/app_button.dart';
import 'package:talaria/widgets/bottom_sheets/terms_of_use_bottom_sheet.dart';
import 'package:talaria/widgets/text_field.dart';
import '../../utils/size_block.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isShowPass = false;
  bool isShowConfirmPass = false;

  final _signUpKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, _) {
      return LoadingOverlay(
        isLoading: provider.isLoading,
        progressIndicator: Loader(),
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              width: Get.width,
              height: Get.height,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.themeColor,
                  AppColors.darkPurple,
                ],
              )),
              child: Column(
                children: [
                  Image.asset(
                    AppImages.logo,
                    height: SizeBlock.v! * 230,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Sign up",
                    style:
                        AppTextStyle.comfortaaBold().copyWith(fontSize: 24.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Expanded(
                    child: Form(
                      key: _signUpKey,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          AppTextField(
                            controller: firstNameController,
                            hintText: "First name",
                            inputType: TextInputType.name,
                            inputAction: TextInputAction.next,
                            validator: FieldValidator.validateFirstName,
                          ),
                          AppTextField(
                            controller: lastNameController,
                            hintText: "Last name",
                            inputType: TextInputType.name,
                            inputAction: TextInputAction.next,
                            validator: FieldValidator.validateSurName,
                          ),
                          AppTextField(
                            controller: emailController,
                            hintText: "Email",
                            inputType: TextInputType.emailAddress,
                            inputAction: TextInputAction.next,
                            validator: FieldValidator.validateEmail,
                          ),
                          AppTextField(
                            controller: passwordController,
                            hintText: "Password",
                            inputType: TextInputType.visiblePassword,
                            inputAction: TextInputAction.next,
                            isPassword: true,
                            showPassword: !isShowPass,
                            validator: FieldValidator.validatePasswordSignup,
                          ),
                          AppTextField(
                            controller: confirmPassController,
                            hintText: "Re - enter Password",
                            inputType: TextInputType.visiblePassword,
                            inputAction: TextInputAction.next,
                            isPassword: true,
                            showPassword: !isShowConfirmPass,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please re-enter password';
                              }
                              if (passwordController.text !=
                                  confirmPassController.text) {
                                return "Password does not match";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.bottomSheet(const TermsOfUseBottomSheet());
                            },
                            child: Text(
                              "By continuing, you agree to our \nterm of service and Privacy Policy",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.comfortaaBold()
                                  .copyWith(fontSize: 10.sp),
                            ),
                          ),
                          Container(
                            width: 70.w,
                            margin: EdgeInsets.symmetric(vertical: 4.h),
                            child: AppButtonWidget(
                              widget: Text("Sign up",
                                  style: AppTextStyle.openSansPurple()
                                      .copyWith(fontSize: SizeBlock.v! * 24)),
                              onTap: () {
                                if (_signUpKey.currentState!.validate()) {
                                  provider.startLoading();
                                  provider.createUser(
                                      context,
                                      addUser(provider),
                                      passwordController.text);
                                }
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: AppTextStyle.comfortaaBold()
                                    .copyWith(fontSize: 10.sp),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.offAll(() => const LoginScreen());
                                },
                                child: Text(
                                  "Log in",
                                  style: AppTextStyle.comfortaaBold()
                                      .copyWith(fontSize: 10.sp),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  UserModel addUser(AuthProvider provider) {
    UserModel user = UserModel(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      isEmailEnabled: true,
      isNotificationEnabled: true,
      createdAt: Timestamp.now(),
      isBlocked: false,
      role: 1,
      email: emailController.text.trim(),
    );

    return user;
  }
}
