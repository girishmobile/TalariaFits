import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:talaria/models/sneaker_model.dart';
import 'package:talaria/provider/add_shoes_from_api_provider.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/images.dart';
import 'package:talaria/utils/size_block.dart';
import 'package:talaria/utils/text_style.dart';

class SneakerNewArrivalWidget extends StatefulWidget {
  AddShoesFromAPIProvider provider;
  APISneakerModel sneakerShoes;

  SneakerNewArrivalWidget(
      {Key? key, required this.provider, required this.sneakerShoes})
      : super(key: key);

  @override
  State<SneakerNewArrivalWidget> createState() =>
      _SneakerNewArrivalWidgetState();
}

class _SneakerNewArrivalWidgetState extends State<SneakerNewArrivalWidget> {
  void initState() {
    // TODO: implement initStatee

    // String imagePath = widget.sneakerShoes.image.original;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
              )
            ],
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width,
                height: SizeBlock.h! * 120,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: AppColors.goldenColor,
                  borderRadius: BorderRadius.circular(20),
                  image: (widget.sneakerShoes.image.original.isEmpty)
                      ? DecorationImage(
                          image: AssetImage(AppImages.placeholder),
                          fit: BoxFit.scaleDown)
                      : DecorationImage(
                          image: CachedNetworkImageProvider(
                              widget.sneakerShoes.image.original),
                          fit: BoxFit.cover),
                ),
                child: GestureDetector(
                    child: Container(
                  padding: EdgeInsets.all(SizeBlock.h! * 7),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.whiteColor,
                  ),
                  child: Consumer<AddShoesFromAPIProvider>(
                    builder: (BuildContext context,
                        AddShoesFromAPIProvider mySneakerProvider,
                        Widget? child) {
                      return (mySneakerProvider.isLoading)
                          ? Container()
                          : Icon(
                              Icons.favorite_border,
                              size: SizeBlock.h! * 15,
                              color: AppColors.greyColor,
                            );
                    },
                  ),
                )),
              ),
              SizedBox(
                height: SizeBlock.v! * 5,
              ),
              Text(
                widget.sneakerShoes.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.roboto().copyWith(
                    fontSize: SizeBlock.v! * 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5),
              ),
              SizedBox(
                height: SizeBlock.v! * 5,
              ),
            ]),
      ),
    );
  }
}
