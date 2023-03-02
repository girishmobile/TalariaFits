import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/provider/auth_provider.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/images.dart';
import 'package:talaria/utils/loader.dart';
import 'package:talaria/utils/size_block.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/widgets/app_button.dart';
import 'package:talaria/widgets/bottom_sheets/change_password_bottom_sheet.dart';
import 'package:talaria/widgets/bottom_sheets/edit_profile_bottom_sheet.dart';

import '../../../widgets/navigation_wrapper_widgets/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, AuthProvider myAuthProvider, _) {
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
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeBlock.h! * 20,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile",
                  style: AppTextStyle.openSansSemiBold().copyWith(color: AppColors.goldenColor, fontSize: SizeBlock.v! * 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: SizeBlock.v! * 10,
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    Divider(
                      color: AppColors.purpleTextColor,
                    ),
                    profileWidget(heading: "Your Photo", data: "", index: 0),
                    profileWidget(
                        heading: "Full Name",
                        data: myAuthProvider.userData.firstName ?? "" +
                            (myAuthProvider.userData.lastName ?? ""),
                        index: 2),
                    profileWidget(
                        heading: "Email",
                        data: myAuthProvider.userData.email ?? "",
                        index: 3),
                    profileWidget(
                        heading: "Phone",
                        data: myAuthProvider.userData.phoneNumber ?? "",
                        index: 4),
                    profileWidget(
                        heading: "Password", data: "Change Password", index: 5),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
                      child: AppButtonWidget(
                        widget: Text(
                          "Edit Profile",
                          style: AppTextStyle.openSansPurple().copyWith(fontSize: SizeBlock.v! * 18)
                        ),
                        onTap: () {
                          Get.bottomSheet(const EditProfileBottomSheet());
                        },
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ));
    });
  }

  Widget profileWidget({String? heading, String? data, int? index}) {
    var provider = Provider.of<AuthProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            switch (index) {
              case 5:
                Get.bottomSheet(const ChangePasswordBottomSheet(),
                    isScrollControlled: true);
                break;
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                heading ?? "",
                style: AppTextStyle.openSansPurple().copyWith(
                    color: AppColors.purpleTextColor, fontSize: 14.sp),
              ),
              index == 0
                  ? Container(
                width: 60,
                      height: 70,
                      decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          border: Border.all(color: AppColors.blackColor)),
                      child: provider.userData.profileImage == null
                          ? Image.asset(
                              AppImages.user,
                              scale: 4,
                            )
                          : CachedNetworkImage(
                              imageUrl: provider.userData.profileImage ?? "",
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Loader(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),fit: BoxFit.cover,
                            ))
                  : Text(
                      data!,
                      style: AppTextStyle.openSansPurple().copyWith(
                        color: AppColors.purpleTextColor,
                      ),
                    ),
            ],
          ),
        ),
        Divider(
          color: AppColors.purpleTextColor,
        ),
      ],
    );
  }
}
