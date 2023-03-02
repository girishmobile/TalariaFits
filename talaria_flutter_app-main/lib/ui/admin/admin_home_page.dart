import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/provider/admin_provider.dart';
import 'package:talaria/ui/admin/add_outfits_pages/add_outfits_select_shoes_page.dart';
import 'package:talaria/ui/admin/add_shoes_from_api/add_shoes_from_api_search_page.dart';
import 'package:talaria/ui/admin/all_shoes_page.dart';
import '../../services/sneakers_service.dart';
import '../../utils/colors.dart';
import '../../utils/size_block.dart';
import '../../utils/text_style.dart';
import '../../widgets/navigation_wrapper_widgets/custom_app_bar.dart';
import 'add_outfits_pages/add_outfits_select_images_page.dart';
import 'edit_brands_page.dart';

class AdminHomePage extends StatefulWidget {
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeBlock.h! * 20,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Admin Panel",
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
                    adminWidget(heading: "All Shoes", onTap: () {
                      Get.to(() => AdminAllShoesScreen());
                    }),
                    adminWidget(heading: "Brands", onTap: () {
                      Get.to(() => EditBrandsPage());
                    }),
                    adminWidget(heading: "Add Outfits", onTap: () {
                      Get.to(() => AdminAddOutfitsSelectShoesScreen());
                    }),
                    adminWidget(heading: "Add Shoes", onTap: () {
                      Get.to(() => AddShoesFromAPISearchPage());
                    }),
                  ],
                ),
              ],
            ),
          ));

  }
  Widget adminWidget({required String heading, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeBlock.h! * 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  heading,
                  style: AppTextStyle.openSansPurple().copyWith(
                      color: AppColors.purpleTextColor, fontSize: 14.sp),
                ),
                Icon(Icons.edit_note_outlined, color: AppColors.purpleTextColor, size: SizeBlock.v! * 45,)
              ],
            ),
          ),
          Divider(
            color: AppColors.purpleTextColor,
          ),
        ],
      ),
    );
  }
}