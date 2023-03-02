import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/provider/auth_provider.dart';
import 'package:talaria/ui/auth/sign_up_screen.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/images.dart';
import 'package:talaria/utils/loader.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/utils/validation.dart';
import 'package:talaria/widgets/app_button.dart';
import 'package:talaria/widgets/bottom_sheets/forgot_password_bottom_sheet.dart';
import 'package:talaria/widgets/text_field.dart';
import '../../utils/size_block.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isShowPassLogin = false;

  final _loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, _) {
      return LoadingOverlay(
        isLoading: provider.isLoading,
        progressIndicator: Loader(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              width: Get.width,
              height: Get.height,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
                    "Login",
                    style: AppTextStyle.comfortaaBold()
                        .copyWith(fontSize: SizeBlock.v! * 40),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Expanded(
                    child: Form(
                      key: _loginKey,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Column(
                            children: [
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
                                inputAction: TextInputAction.done,
                                isPassword: true,
                                showPassword: !isShowPassLogin,
                                validator:
                                    FieldValidator.validatePasswordSignup,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(
                                        const ForgotPasswordBottomSheet());
                                  },
                                  child: Text(
                                    "Forgot password?",
                                    style: AppTextStyle.comfortaaBold(),
                                  ),
                                ),
                              ),
                              Container(
                                width: 70.w,
                                margin: EdgeInsets.symmetric(vertical: 4.h),
                                child: AppButtonWidget(
                                  widget: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        AppImages.google,
                                        scale: 5,
                                        color: Colors.transparent,
                                      ),
                                      Text("Log in",
                                          style: AppTextStyle.openSansPurple()
                                              .copyWith(
                                                  fontSize: SizeBlock.v! * 24)),
                                      Image.asset(
                                        AppImages.google,
                                        scale: 5,
                                        color: Colors.transparent,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    if (_loginKey.currentState!.validate()) {
                                      provider.startLoading();
                                      provider.loginUser(
                                          context,
                                          emailController.text.trim(),
                                          passwordController.text);
                                    }
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Divider(
                                    color: AppColors.whiteColor,
                                    endIndent: 20,
                                  )),
                                  Text(
                                    "OR",
                                    style: AppTextStyle.comfortaaBold(),
                                  ),
                                  Expanded(
                                      child: Divider(
                                    color: AppColors.whiteColor,
                                    indent: 20,
                                  ))
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  provider.startLoading();
                                  provider.googleSignIn(context);
                                },
                                child: Container(
                                  width: 70.w,
                                  margin: EdgeInsets.symmetric(vertical: 4.h),
                                  child: AppButtonWidget(
                                    widget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          AppImages.google,
                                          scale: 5,
                                        ),
                                        Text("Login with google",
                                            style: AppTextStyle.openSansPurple()
                                                .copyWith(
                                                    fontSize:
                                                        SizeBlock.v! * 18)),
                                        Image.asset(
                                          AppImages.google,
                                          scale: 5,
                                          color: Colors.transparent,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don’t have an account? ",
                                style: AppTextStyle.comfortaaBold()
                                    .copyWith(fontSize: 10.sp),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => const SignUpScreen());
                                },
                                child: Text(
                                  "Sign up",
                                  style: AppTextStyle.comfortaaBold()
                                      .copyWith(fontSize: 10.sp),
                                ),
                              ),
                            ],
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
}
