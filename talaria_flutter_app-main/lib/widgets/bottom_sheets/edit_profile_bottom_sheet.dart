import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/constants/fb_collections.dart';
import 'package:talaria/models/user_model.dart';
import 'package:talaria/provider/auth_provider.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/images.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/widgets/app_button.dart';
import '../../utils/loader.dart';
import '../../utils/size_block.dart';

class EditProfileBottomSheet extends StatefulWidget {
  const EditProfileBottomSheet({Key? key}) : super(key: key);

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    var p = Provider.of<AuthProvider>(context,listen: false);
    firstNameController.text = p.userData.firstName ?? "";
    lastNameController.text = p.userData.lastName ?? "";
    phoneController.text = p.userData.phoneNumber ?? "";
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, _) {
      return LoadingOverlay(
        isLoading: provider.isLoading,
        progressIndicator: Loader(),
        child: Container(
          width: Get.width,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  Text(
                    "Edit Profile",
                    style:
                    AppTextStyle.openSansPurple().copyWith(fontSize: 14.sp, color: AppColors.goldenColor),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  GestureDetector(
                    onTap: (){
                      provider.getProfileImage();
                    },
                    child: Container(
                        width: 80,
                        height: 100,
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
                        )),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  TextFormField(
                    controller: firstNameController,
                    cursorColor: AppColors.purpleTextColor,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,

                    style: AppTextStyle.comfortaaBold().copyWith(
                        fontSize: 10.sp, color: AppColors.purpleTextColor),
                    decoration: InputDecoration(
                      hintText: "First Name",
                      fillColor: AppColors.skinColor,
                      filled: true,
                      isDense: true,
                      hintStyle: AppTextStyle.comfortaaBold().copyWith(
                          fontSize: 10.sp, color: AppColors.purpleTextColor),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: AppColors.skinColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: AppColors.skinColor)),
                      errorBorder: null,
                      focusedErrorBorder: null,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  TextFormField(
                    controller: lastNameController,
                    cursorColor: AppColors.purpleTextColor,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,

                    style: AppTextStyle.comfortaaBold().copyWith(
                        fontSize: 10.sp, color: AppColors.purpleTextColor),
                    decoration: InputDecoration(
                      hintText: "Last Name",
                      fillColor: AppColors.skinColor,
                      filled: true,
                      isDense: true,
                      hintStyle: AppTextStyle.comfortaaBold().copyWith(
                          fontSize: 10.sp, color: AppColors.purpleTextColor),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: AppColors.skinColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: AppColors.skinColor)),
                      errorBorder: null,
                      focusedErrorBorder: null,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  TextFormField(
                    controller: phoneController,
                    cursorColor: AppColors.purpleTextColor,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,

                    style: AppTextStyle.comfortaaBold().copyWith(
                        fontSize: 10.sp, color: AppColors.purpleTextColor),
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      fillColor: AppColors.skinColor,
                      filled: true,
                      isDense: true,
                      hintStyle: AppTextStyle.comfortaaBold().copyWith(
                          fontSize: 10.sp, color: AppColors.purpleTextColor),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: AppColors.skinColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: AppColors.skinColor)),
                      errorBorder: null,
                      focusedErrorBorder: null,
                    ),
                  ),
                  Container(
                    width: 70.w,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    child: AppButtonWidget(
                      widget: Text(
                        "Save",
                        style: AppTextStyle.openSansPurple().copyWith(fontSize: SizeBlock.v! * 18),
                      ),
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          provider.startLoading();
                          Map<String, dynamic> body = {
                            "first_name": firstNameController.text,
                            "last_name": lastNameController.text,
                            "phone_number": phoneController.text,
                          };
                          //print(UserProfileStatusType.COMPLETE_PROFILE);
                          await FBCollections.users.doc(provider.userData.email).update(body);
                          UserModel? userModel =
                          await provider.getUserFromDB(provider.userData.email ?? "");
                          provider.userData = userModel!;
                          DashboardProvider dash =
                          Provider.of<DashboardProvider>(context, listen: false);
                          dash.userData = userModel;
                          provider.stopLoading();
                          Get.back();
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
