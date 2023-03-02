import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talaria/models/sneaker_model.dart';

import '../../utils/colors.dart';
import '../../utils/size_block.dart';
import '../../utils/text_style.dart';

class ShoesFromAPIWidget extends StatelessWidget {
  APISneakerModel apiSneakerModel;
  VoidCallback onTap;

  ShoesFromAPIWidget({Key? key, required this.apiSneakerModel, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        print(apiSneakerModel);
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: double.infinity,
              height: SizeBlock.v! * 123,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(1, 1), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: EdgeInsets.all(SizeBlock.v! * 10),
                  child: CachedNetworkImage(
                    imageUrl: apiSneakerModel.image.thumbnail,
                    fit: BoxFit.cover,
                    errorWidget: (error, _, __) => Center(child: Text("Image Missing", style: AppTextStyle.openSansPurple().copyWith(fontWeight: FontWeight.w500, fontSize: SizeBlock.v! * 16, color: Colors.grey),)),
                  ),
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeBlock.h! * 10),
            child: Text(
              "${apiSneakerModel.name}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.openSansPurple().copyWith(fontWeight: FontWeight.w600, fontSize: SizeBlock.v! * 16),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeBlock.h! * 10),
              child: Text(
                apiSneakerModel.story,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.openSansPurple().copyWith(fontWeight: FontWeight.w400, fontSize: SizeBlock.v! * 14),

              ),
            ),
          ),
        ],
      ),
    );
  }

}