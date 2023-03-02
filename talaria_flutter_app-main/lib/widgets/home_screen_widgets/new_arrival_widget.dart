import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../models/shoes_model.dart';
import '../../provider/dashboard_provider.dart';
import '../../ui/dashboard/product_detail_screen.dart';
import '../../utils/colors.dart';
import '../../utils/size_block.dart';
import '../../utils/text_style.dart';

class NewArrivalWidget extends StatefulWidget {
  DashboardProvider provider;
  ShoesDataModel shoeData;

  NewArrivalWidget({Key? key, required this.provider, required this.shoeData})
      : super(key: key);

  @override
  State<NewArrivalWidget> createState() => _NewArrivalWidgetState();
}

class _NewArrivalWidgetState extends State<NewArrivalWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailScreen(
              shoes: widget.shoeData,
            ));
      },
      child: Container(
        clipBehavior: Clip.none,
        width: SizeBlock.h! * 185,
        padding: EdgeInsets.all(SizeBlock.h! * 10),
        margin: EdgeInsets.symmetric(vertical: SizeBlock.v! * 10),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              height: SizeBlock.v! * 120,
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                  color: AppColors.goldenColor,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          widget.shoeData.mainImage!),
                      fit: BoxFit.cover)),
              child: GestureDetector(
                onTap: () {
                  widget.provider.addRemoveFav(widget.shoeData.id ?? "");
                },
                child: Container(
                  padding: EdgeInsets.all(SizeBlock.h! * 7),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.whiteColor),
                  child: Consumer<DashboardProvider>(
                    builder: (BuildContext context,
                        DashboardProvider myDashboardProvider, Widget? child) {
                      return (myDashboardProvider.isLoading)
                          ? Container()
                          : Icon(
                              (myDashboardProvider.favouriteList.indexWhere(
                                          (element) =>
                                              widget.shoeData.id ==
                                              element.shoesId) !=
                                      -1)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: (myDashboardProvider.favouriteList
                                          .indexWhere((element) =>
                                              widget.shoeData.id ==
                                              element.shoesId) !=
                                      -1)
                                  ? AppColors.redColor
                                  : AppColors.blackColor,
                              size: SizeBlock.h! * 15,
                            );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeBlock.v! * 5,
            ),
            Text(
              "${widget.shoeData.name}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.roboto().copyWith(
                  fontSize: SizeBlock.v! * 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5),
            ),
            if (widget.shoeData.shoesRatingValue != 0)
              SizedBox(
                height: SizeBlock.v! * 5,
              ),
            if (widget.shoeData.shoesRatingValue != 0)
              Text(
                "Rating (${widget.shoeData.shoesRatingValue.toStringAsFixed(1)})",
                style: AppTextStyle.roboto().copyWith(
                    fontSize: SizeBlock.v! * 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5),
              ),
            SizedBox(
              height: SizeBlock.v! * 5,
            ),
          ],
        ),
      ),
    );
  }
}
