import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/models/my_closet_model.dart';
import 'package:talaria/models/shoes_model.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/widgets/app_button.dart';
import 'package:talaria/widgets/navigation_wrapper_widgets/custom_app_bar.dart';
import '../../utils/size_block.dart';
import '../../widgets/dialogs/outfits_dialog.dart';

class ClosetScreenDetails extends StatefulWidget {
  final ShoesDataModel? shoes;
  final MyClosetModel? closetModel;

  const ClosetScreenDetails({Key? key, this.shoes, this.closetModel})
      : super(key: key);

  @override
  State<ClosetScreenDetails> createState() => _ClosetScreenDetailsState();
}

class _ClosetScreenDetailsState extends State<ClosetScreenDetails> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
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
            padding: EdgeInsets.symmetric(horizontal: SizeBlock.h! * 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Details",
                  style: AppTextStyle.openSansSemiBold().copyWith(
                      color: AppColors.goldenColor,
                      fontSize: SizeBlock.v! * 22,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: SizeBlock.v! * 10,
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 25.h,
                        width: Get.width,
                        child: PageView(
                          controller: controller,
                          children: List.generate(
                            1,
                              // widget.closetModel!.selectedColor!.sliderImagesUrl!
                              //     .length,
                              (index) => ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Card(
                                  color: AppColors.whiteColor,
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  elevation: 5,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.shoes!.mainImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: SizeBlock.v! * 10,
                      ),
                      Center(
                          child: Text(
                            (widget.shoes?.name ?? ""),
                        style: AppTextStyle.openSansSemiBold().copyWith(
                            color: AppColors.purpleTextColor,
                            fontSize: SizeBlock.v! * 18,
                            fontWeight: FontWeight.w600),
                      )),
                      SizedBox(
                        height: SizeBlock.v! * 15,
                      ),
                      if (widget.shoes?.outfitsImages?.isNotEmpty ?? false) AppButtonWidget(
                        widget: Text(
                            "Check Matching Outfits",
                            style: AppTextStyle.openSansPurple().copyWith(fontSize: SizeBlock.v! * 18)
                        ),
                        onTap: () {
                          Get.dialog(OutfitsDialog(
                            shoes: widget.shoes,
                          ));
                        },
                      ),
                      SizedBox(
                        height: SizeBlock.v! * 15,
                      ),
                      Text("Product Description",
                        style: AppTextStyle.openSansSemiBold().copyWith(
                            color: AppColors.purpleTextColor,
                            fontSize: SizeBlock.v! * 24,
                            fontWeight: FontWeight.w600)),
                      SizedBox(
                        height: SizeBlock.v! * 15,
                      ),
                      Text(widget.shoes?.description ?? "",
                          style: AppTextStyle.openSansSemiBold().copyWith(
                              color: AppColors.purpleTextColor,
                              fontSize: SizeBlock.v! * 22,
                              fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: SizeBlock.v! * 15,
                      ),
                      Divider(
                        color: AppColors.purpleTextColor,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text("Color",
                      //         style: AppTextStyle.comfortaaBold().copyWith(
                      //             fontSize: 14.sp,
                      //             color: AppColors.purpleTextColor)),
                      //     Text(widget.closetModel!.selectedColor ?? "",
                      //         style: AppTextStyle.openSansPurple().copyWith(
                      //             fontSize: 14.sp,
                      //             color: AppColors.purpleTextColor)),
                      //   ],
                      // ),
                      // Divider(
                      //   color: AppColors.purpleTextColor,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Brand",
                              style: AppTextStyle.comfortaaBold().copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.purpleTextColor)),
                          Text(widget.shoes?.brand ?? "",
                              style: AppTextStyle.openSansPurple().copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.purpleTextColor)),
                        ],
                      ),

                      Divider(
                        color: AppColors.purpleTextColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Size",
                              style: AppTextStyle.comfortaaBold().copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.purpleTextColor)),
                          Text(widget.closetModel?.selectedSize!.toStringAsFixed(1) ?? "",
                              style: AppTextStyle.openSansPurple().copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.purpleTextColor)),
                        ],
                      ),
                      Divider(
                        color: AppColors.purpleTextColor,
                      ),
                      AppButtonWidget(
                        widget: Text(
                            "Remove From Closet",
                            style: AppTextStyle.openSansPurple().copyWith(fontSize: SizeBlock.v! * 18)
                        ),
                        onTap: () {
                          provider.removeFromCloset(context, widget.shoes!.id!);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
