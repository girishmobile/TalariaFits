import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/shoes_model.dart';
import '../../provider/dashboard_provider.dart';
import '../../ui/dashboard/product_detail_screen.dart';
import '../../utils/colors.dart';
import '../../utils/size_block.dart';
import '../../utils/text_style.dart';

class FavoriteShoeWidget extends StatelessWidget {
  DashboardProvider provider; ShoesDataModel shoe;


  FavoriteShoeWidget({required this.provider, required this.shoe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailScreen(
          shoes: shoe,
        ));
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: SizeBlock.v! * 20),
        child: Material(
          borderRadius: BorderRadius.circular(SizeBlock.v! * 10),
          elevation: 5,
          child: Container(
            height: SizeBlock.v! * 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeBlock.v! * 10),
              color: AppColors.whiteColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding:  EdgeInsets.all(SizeBlock.v! * 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shoe.name ?? "",
                          style: AppTextStyle.openSansPurple().copyWith(fontSize: SizeBlock.v! * 14, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: SizeBlock.v! * 5,
                        ),
                        Expanded(
                          child: Text(
                            shoe.description ?? "",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.openSansPurple().copyWith(fontSize: SizeBlock.v! * 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: SizeBlock.h! * 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: SizeBlock.h! * 160,
                      alignment: Alignment.topRight,
                      decoration: BoxDecoration(
                          color: AppColors.goldenColor,
                          borderRadius: BorderRadius.circular(SizeBlock.v! * 30),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(SizeBlock.v! * 30),
                        child: CachedNetworkImage(
                            height: SizeBlock.v! * 110,
                            width: SizeBlock.h! * 160,
                          imageUrl: shoe.mainImage!,
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        provider.addRemoveFav(shoe.id ?? "");
                        // shoes?.isFavourite = !shoes.isFavourite!;
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          provider.checkFav(shoe.id ?? "")
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: provider.checkFav(shoe.id ?? "")
                              ? AppColors.redColor
                              : AppColors.blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
