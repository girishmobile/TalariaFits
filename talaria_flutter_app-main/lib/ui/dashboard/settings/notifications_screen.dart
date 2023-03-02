import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/constants/fb_collections.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/loader.dart';
import 'package:talaria/utils/text_style.dart';
import '../../../utils/size_block.dart';
import '../../../widgets/navigation_wrapper_widgets/custom_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, _) {
      return LoadingOverlay(
        isLoading: provider.isLoading,
        progressIndicator: Loader(),
        child: Scaffold(
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
              Text(
                "Notifications",
                style: AppTextStyle.openSansSemiBold()
                    .copyWith(color: AppColors.goldenColor, fontSize: 14.sp),
              ),
              SizedBox(
                height: 2.h,
              ),
              Divider(
                color: AppColors.purpleTextColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Push Notifications",
                    style: AppTextStyle.openSansPurple().copyWith(
                        color: AppColors.purpleTextColor, fontSize: 14.sp),
                  ),
                  FlutterSwitch(
                    width: 60.0,
                    height: 30.0,
                    toggleSize: 20.0,
                    value: provider.pushNotifications,
                    borderRadius: 30.0,
                    padding: 4.0,
                    showOnOff: false,
                    activeColor: AppColors.themeColor,
                    activeToggleColor: AppColors.goldenColor,
                    onToggle: (val) async {
                      provider.startLoading();
                      await FBCollections.users
                          .doc(provider.userData.email)
                          .update({"is_notification_enabled": val});
                      setState(() {
                        provider.pushNotifications = val;
                      });
                      provider.stopLoading();
                    },
                  ),
                ],
              ),
              Divider(
                color: AppColors.purpleTextColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Email Notifications",
                    style: AppTextStyle.openSansPurple().copyWith(
                        color: AppColors.purpleTextColor, fontSize: 14.sp),
                  ),
                  FlutterSwitch(
                    width: 60.0,
                    height: 30.0,
                    toggleSize: 20.0,
                    value: provider.emailNotifications,
                    borderRadius: 30.0,
                    padding: 4.0,
                    showOnOff: false,
                    activeColor: AppColors.themeColor,
                    activeToggleColor: AppColors.goldenColor,
                    onToggle: (val) async {
                      provider.startLoading();
                      await FBCollections.users
                          .doc(provider.userData.email)
                          .update({"is_email_enabled": val});
                      setState(() {
                        provider.emailNotifications = val;
                      });
                      provider.stopLoading();
                    },
                  ),
                ],
              ),
              Divider(
                color: AppColors.purpleTextColor,
              ),
            ],
          ),
        ),
      );
    });
  }
}
