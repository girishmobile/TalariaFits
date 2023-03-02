// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/shoes_model.dart';
import '../../utils/colors.dart';
import '../../utils/size_block.dart';
import '../../utils/text_style.dart';

class SearchListWidget extends StatelessWidget {
  ShoesDataModel? shoes;
  Function onTap;

  SearchListWidget({Key? key, required this.shoes, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                color: AppColors.goldenColor,
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
                child: CachedNetworkImage(
                  imageUrl: shoes?.mainImage ?? "",
                  fit: BoxFit.cover,
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeBlock.h! * 10),
            child: Text(
              "${shoes?.name}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.openSansPurple().copyWith(
                  fontWeight: FontWeight.w600, fontSize: SizeBlock.v! * 16),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeBlock.h! * 10),
              child: Text(
                shoes?.description ?? "",
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.openSansPurple().copyWith(
                    fontWeight: FontWeight.w400, fontSize: SizeBlock.v! * 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
