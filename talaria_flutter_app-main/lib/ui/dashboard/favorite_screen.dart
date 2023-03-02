import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/ui/dashboard/dashboard_screen.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/images.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/widgets/app_button.dart';
import '../../utils/size_block.dart';
import '../../widgets/favorites_widgets/favorite_shoe_widget.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, _) {
      return Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: provider.favouriteList.isEmpty
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppImages.heartSVG,
                      color: AppColors.redColor,
                    ),
                    SizedBox(
                      height: SizeBlock.v! * 25,
                    ),
                    Text(
                      "Looks like you don’t have any favorites",
                      style: AppTextStyle.openSansPurple().copyWith(
                          color: AppColors.purpleTextColor, fontSize: 14.sp),
                    ),
                    Container(
                      width: SizeBlock.h! * 285,
                      margin: EdgeInsets.only(top: 15.h),
                      child: AppButtonWidget(
                        widget: Text(
                          "Start Browsing",
                            style: AppTextStyle.openSansPurple().copyWith(fontSize: SizeBlock.v! * 18)
                        ),
                        onTap: () {
                          Get.offAll(() => const DashboardScreen());
                        },
                      ),
                    ),
                  ],
                ))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Favorites",
                      style: AppTextStyle.openSansSemiBold().copyWith(color: AppColors.goldenColor, fontSize: SizeBlock.v! * 22, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: SizeBlock.v! * 10,),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(bottom: SizeBlock.v! * 100, left: SizeBlock.h! * 2, right: SizeBlock.h! * 2),
                        shrinkWrap: true,
                        children: [
                          ...List.generate(provider.favouriteList.length,
                              (index) {
                            int shoesIndex = provider.shoeList.indexWhere(
                                (element) =>
                                    element.id ==
                                    provider.favouriteList[index].shoesId);
                            if (shoesIndex != -1) {
                              return FavoriteShoeWidget(
                                  provider: provider,
                                  shoe: provider.shoeList[shoesIndex]);
                            } else {
                              return SizedBox();
                            }
                          })
                        ],
                      ),
                    ),
                  ],
                ));
    });
  }
}
