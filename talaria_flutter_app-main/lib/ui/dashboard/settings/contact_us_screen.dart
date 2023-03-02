import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/images.dart';
import 'package:talaria/utils/show_message.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/size_block.dart';
import '../../../widgets/navigation_wrapper_widgets/custom_app_bar.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
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
          GestureDetector(
            onTap: () {
              Clipboard.setData(const ClipboardData(text: "123 St 5, Romford"));
              ShowMessage.toast(msg: "Address Copied");
            },
            child: Container(
              width: Get.width,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppImages.pin,
                    scale: 3,
                    color: AppColors.themeColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Address",
                        style: AppTextStyle.openSansSemiBold(),
                      ),
                      Text(
                        "123 St 5, Romford",
                        style: AppTextStyle.openSansSemiBold()
                            .copyWith(fontSize: 10.sp),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final Uri launchUri = Uri(
                scheme: 'tel',
                path: "+9345613819",
              );
              await launch(launchUri.toString());
            },
            child: Container(
              width: Get.width,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Image.asset(
                      AppImages.phone,
                      scale: 3,
                      color: AppColors.themeColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Telephone",
                        style: AppTextStyle.openSansSemiBold(),
                      ),
                      Text(
                        "+9345613819",
                        style: AppTextStyle.openSansSemiBold()
                            .copyWith(fontSize: 10.sp),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              String? encodeQueryParameters(Map<String, String> params) {
                return params.entries
                    .map((e) =>
                        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                    .join('&');
              }

              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: "talaria@gmail.com",
                query: encodeQueryParameters(<String, String>{
                  // 'subject': 'Example Subject'
                }),
              );

              launch(emailLaunchUri.toString());
            },
            child: Container(
              width: Get.width,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Image.asset(
                      AppImages.email,
                      scale: 3,
                      color: AppColors.themeColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: AppTextStyle.openSansSemiBold(),
                      ),
                      Text(
                        "talaria@gmail.com",
                        style: AppTextStyle.openSansSemiBold()
                            .copyWith(fontSize: 10.sp),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(const ClipboardData(text: "www.talaria.com"));
              ShowMessage.toast(msg: "Website link Copied");
            },
            child: Container(
              width: Get.width,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Image.asset(
                      AppImages.url,
                      scale: 3,
                      color: AppColors.themeColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Website",
                        style: AppTextStyle.openSansSemiBold(),
                      ),
                      Text(
                        "www.talaria.com",
                        style: AppTextStyle.openSansSemiBold()
                            .copyWith(fontSize: 10.sp),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
