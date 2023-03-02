import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../utils/colors.dart';
import '../../utils/size_block.dart';
import '../../utils/text_style.dart';

class BrandWidget extends StatelessWidget {
  String heading;
  VoidCallback onTap;

  BrandWidget({required this.heading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeBlock.h! * 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  heading,
                  style: AppTextStyle.openSansPurple().copyWith(
                      color: AppColors.purpleTextColor, fontSize: 14.sp),
                ),
              ),
              GestureDetector(
                  onTap: () => onTap(),
                  child: Icon(Icons.remove_circle_outline_rounded, color: AppColors.redColor, size: SizeBlock.v! * 45,))
            ],
          ),
        ),
        Divider(
          color: AppColors.purpleTextColor,
        ),
      ],
    );
  }
}