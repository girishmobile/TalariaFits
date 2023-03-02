import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:talaria/constants/text_constants.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/dummy.dart';
import 'package:talaria/utils/text_style.dart';
import '../../../utils/size_block.dart';
import '../../../widgets/navigation_wrapper_widgets/custom_app_bar.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        leadingWith: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: SizeBlock.v! * 30,
                  color: AppColors.blackColor,
                ));
          },
        ),
        endingWith: Icon(
          Icons.arrow_back_ios_rounded,
          size: SizeBlock.v! * 30,
          color: Colors.transparent,
        ),
        height: SizeBlock.v! * 160,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        children: [
          HtmlWidget(
            TextConstants.termsOfUse,
            textStyle: AppTextStyle.openSansPurple(),
          ),
        ],
      ),
    );
  }
}
