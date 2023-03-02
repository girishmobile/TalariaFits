import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/shoes_model.dart';
import '../../provider/dashboard_provider.dart';
import '../../ui/dashboard/product_detail_screen.dart';
import '../../utils/colors.dart';
import '../../utils/size_block.dart';
import '../../utils/text_style.dart';

class MostPopularWidget extends StatelessWidget {
  DashboardProvider provider;
  ShoesDataModel shoeData;

  MostPopularWidget({required this.provider, required this.shoeData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailScreen(
              shoes: shoeData,
            ));
      },
      child: Container(
        padding: EdgeInsets.all(SizeBlock.h! * 20),
        margin: EdgeInsets.symmetric(vertical: SizeBlock.v! * 10),
        decoration: BoxDecoration(
            color: AppColors.goldenColor,
            borderRadius: BorderRadius.circular(SizeBlock.h! * 30)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //TODO make sure this is clickable
            Container(
              clipBehavior: Clip.none,
              padding: EdgeInsets.all(SizeBlock.h! * 15),
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(SizeBlock.h! * 25)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${shoeData.name}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.roboto().copyWith(
                              fontSize: SizeBlock.v! * 20,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1.5,
                              color: AppColors.purpleTextColor),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          provider.addRemoveFav(shoeData.id ?? "");
                        },
                        child: Container(
                          padding: EdgeInsets.all(SizeBlock.v! * 5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.goldenColor),
                          child: Center(
                            child: Icon(
                              provider.checkFav(shoeData.id ?? "")
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: provider.checkFav(shoeData.id ?? "")
                                  ? AppColors.redColor
                                  : AppColors.whiteColor,
                              size: SizeBlock.h! * 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeBlock.v! * 5,
                  ),
                  SizedBox(
                    height: SizeBlock.v! * 150,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: shoeData.mainImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(height: SizeBlock.v! * 10,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Text(
            //       "Rating (${shoeData.shoesRatingValue.toStringAsFixed(1)})",
            //       style: AppTextStyle.roboto().copyWith(fontSize: SizeBlock.v! * 20, fontWeight: FontWeight.w400, letterSpacing: 1.25, color: AppColors.blackColor),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
