import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/provider/auth_provider.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/images.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/utils/validation.dart';
import 'package:talaria/widgets/app_button.dart';
import 'package:talaria/widgets/text_field.dart';

class ForgotPasswordBottomSheet extends StatefulWidget {
  const ForgotPasswordBottomSheet({Key? key}) : super(key: key);

  @override
  _ForgotPasswordBottomSheetState createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, _) {
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          width: Get.width,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    endIndent: 35.w,
                    indent: 35.w,
                    thickness: 2,
                    color: AppColors.blackColor.withOpacity(0.4),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Image.asset(
                    AppImages.lock,
                    scale: 3,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Forgot Password?",
                    style:
                        AppTextStyle.comfortaaBold().copyWith(fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Enter your registered Email to get OTP.",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.openSansSemiBold(),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  AppTextField(
                    controller: emailController,
                    hintText: "Email",
                    inputType: TextInputType.emailAddress,
                    inputAction: TextInputAction.done,
                    validator: FieldValidator.validateEmail,
                    style: AppTextStyle.comfortaaBold().copyWith(
                        fontSize: 10.sp, color: AppColors.purpleTextColor),
                  ),
                  Container(
                    width: 70.w,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    child: AppButtonWidget(
                      widget: Text(
                        "Proceed",
                        style: AppTextStyle.comfortaaBold().copyWith(
                            fontSize: 16.sp, color: AppColors.themeColor),
                      ),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          provider.startLoading();
                          provider.resetPassword(emailController.text.trim());
                        }
                      },
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
