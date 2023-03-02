import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/size_block.dart';
import '../../utils/text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Widget leadingWith;
  final Widget endingWith;
  final title;

  CustomAppBar(
      {required this.height,
      required this.leadingWith,
      required this.endingWith,
      this.title = ""});

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: preferredSize,
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Stack(
            children: <Widget>[
              Container(
                width: double.maxFinite,
                height: preferredSize.height,
                color: AppColors.whiteColor,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: SizeBlock.h! * 15, right: SizeBlock.h! * 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: SizeBlock.h! * 50, child: leadingWith),
                      (title == "")
                          ? SizedBox(
                              width: SizeBlock.h! * 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    AppImages.logo,
                                    fit: BoxFit.fill,
                                    scale: 8,
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              title,
                              style: AppTextStyle.openSansSemiBold().copyWith(
                                  fontSize: SizeBlock.v! * 30,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackColor),
                            ),
                      SizedBox(width: SizeBlock.h! * 50, child: endingWith)
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
