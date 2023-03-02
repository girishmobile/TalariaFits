import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/constants/text_constants.dart';
import 'package:talaria/provider/auth_provider.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/images.dart';
import 'package:talaria/utils/size_block.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/utils/validation.dart';
import 'package:talaria/widgets/app_button.dart';
import 'package:talaria/widgets/text_field.dart';

class TermsOfUseBottomSheet extends StatefulWidget {
  const TermsOfUseBottomSheet({Key? key}) : super(key: key);

  @override
  _TermsOfUseBottomSheetState createState() =>
      _TermsOfUseBottomSheetState();
}

class _TermsOfUseBottomSheetState extends State<TermsOfUseBottomSheet> {
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
          child: SingleChildScrollView(
            child: Text(
              TextConstants.termsOfUse,
              style: AppTextStyle.openSansPurple().copyWith(fontSize: SizeBlock.v! * 16),
            ),
          ),
        ),
      );
    });
  }
}
