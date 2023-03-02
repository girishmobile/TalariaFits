import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/provider/auth_provider.dart';
import 'package:talaria/ui/dashboard/settings/contact_us_screen.dart';
import 'package:talaria/ui/dashboard/settings/notifications_screen.dart';
import 'package:talaria/ui/dashboard/settings/profile_screen.dart';
import 'package:talaria/ui/dashboard/settings/terms_screen.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/widgets/app_button.dart';

import '../../../utils/size_block.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Account",
              style: AppTextStyle.openSansSemiBold().copyWith(
                  color: AppColors.goldenColor,
                  fontSize: SizeBlock.v! * 22,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: SizeBlock.v! * 10),
            ListView(
              shrinkWrap: true,
              children: [
                Divider(
                  color: AppColors.purpleTextColor,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const ProfileScreen());
                  },
                  child: Text(
                    "Profile",
                    style: AppTextStyle.openSansPurple().copyWith(
                        color: AppColors.purpleTextColor, fontSize: 14.sp),
                  ),
                ),
                Divider(
                  color: AppColors.purpleTextColor,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const NotificationsScreen());
                  },
                  child: Text(
                    "Notifications",
                    style: AppTextStyle.openSansPurple().copyWith(
                        color: AppColors.purpleTextColor, fontSize: 14.sp),
                  ),
                ),
                Divider(
                  color: AppColors.purpleTextColor,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const ContactUsScreen());
                  },
                  child: Text(
                    "Contact us",
                    style: AppTextStyle.openSansPurple().copyWith(
                        color: AppColors.purpleTextColor, fontSize: 14.sp),
                  ),
                ),
                Divider(
                  color: AppColors.purpleTextColor,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const TermsScreen());
                  },
                  child: Text(
                    "Terms of use",
                    style: AppTextStyle.openSansPurple().copyWith(
                        color: AppColors.purpleTextColor, fontSize: 14.sp),
                  ),
                ),
                Divider(
                  color: AppColors.purpleTextColor,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: SizeBlock.v! * 20,
                  ),
                  child: AppButtonWidget(
                    widget: Text("Log Out",
                        style: AppTextStyle.openSansPurple()
                            .copyWith(fontSize: SizeBlock.v! * 18)),
                    onTap: () {
                      provider.logoutUser(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
