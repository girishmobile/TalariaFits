import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/provider/auth_provider.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/images.dart';
import 'package:talaria/utils/loader.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/utils/validation.dart';
import 'package:talaria/widgets/app_button.dart';
import 'package:talaria/widgets/text_field.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({Key? key}) : super(key: key);

  @override
  _ChangePasswordBottomSheetState createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool isShowPass = false;
  bool isShowConfirmPass = false;
  bool isShowOldPass = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, _) {
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: LoadingOverlay(
          isLoading: provider.isLoading,
          progressIndicator: Loader(),
          child: Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
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
                      "New Password?",
                      style: AppTextStyle.comfortaaBold()
                          .copyWith(fontSize: 14.sp),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "must include upper case, numbers and symbols.",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.openSansSemiBold(),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    AppTextField(
                      controller: oldPassController,
                      hintText: "Old Password",
                      inputType: TextInputType.visiblePassword,
                      inputAction: TextInputAction.next,
                      isPassword: true,
                      showPassword: !isShowOldPass,
                      validator: FieldValidator.validatePasswordSignup,
                      style: AppTextStyle.comfortaaBold().copyWith(
                          fontSize: 10.sp, color: AppColors.purpleTextColor),
                    ),
                    AppTextField(
                      controller: newPassController,
                      hintText: "New Password",
                      inputType: TextInputType.visiblePassword,
                      inputAction: TextInputAction.next,
                      isPassword: true,
                      showPassword: !isShowPass,
                      validator: FieldValidator.validatePasswordSignup,
                      style: AppTextStyle.comfortaaBold().copyWith(
                          fontSize: 10.sp, color: AppColors.purpleTextColor),
                    ),
                    AppTextField(
                      controller: confirmPassController,
                      hintText: "Re - enter Password",
                      inputType: TextInputType.visiblePassword,
                      inputAction: TextInputAction.done,
                      isPassword: true,
                      showPassword: !isShowConfirmPass,
                      style: AppTextStyle.comfortaaBold().copyWith(
                          fontSize: 10.sp, color: AppColors.purpleTextColor),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please re-enter password';
                        }
                        if (newPassController.text !=
                            confirmPassController.text) {
                          return "Password does not match";
                        }
                        return null;
                      },
                    ),
                    Container(
                      width: 70.w,
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      child: AppButtonWidget(
                        widget: Text(
                          "Save",
                          style: AppTextStyle.comfortaaBold().copyWith(
                              fontSize: 16.sp, color: AppColors.themeColor),
                        ),
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            provider.startLoading();
                            provider.changePassword(
                                oldPassController.text, newPassController.text);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
