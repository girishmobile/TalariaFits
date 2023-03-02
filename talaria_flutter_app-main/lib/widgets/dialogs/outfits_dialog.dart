import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:talaria/models/shoes_model.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/size_block.dart';

class OutfitsDialog extends StatefulWidget {
  final ShoesDataModel? shoes;

  const OutfitsDialog({Key? key, this.shoes}) : super(key: key);

  @override
  _OutfitsDialogState createState() => _OutfitsDialogState();
}

class _OutfitsDialogState extends State<OutfitsDialog> {
  PageController pageController = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
    child: Dialog(
      backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.themeColor,
                  AppColors.darkPurple,
                ],
              ),
              borderRadius: BorderRadius.circular(20)),
          height: SizeBlock.v! * 600,
          child: Center(
            child: Stack(
              children: [
                PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  padEnds: true,
                  controller: pageController,
                  onPageChanged: (val) {
                    pageIndex = val;
                  },
                  children: List.generate(
                      widget.shoes?.outfitsImages?.length ?? 0, (index) {
                    String outfitID = widget.shoes?.outfitsImages?.keys.elementAt(index) ?? "";
                    return FittedBox(
                      fit: BoxFit.fill,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                            imageUrl: widget.shoes?.outfitsImages?[outfitID] ?? "",
                            fit: BoxFit.cover),
                      ),
                    );
                  }, ),
                ),
                if (pageIndex != 0) Positioned.fill(
                  child: Align(
                    child: GestureDetector(
                      onTap: () {
                        pageController.jumpToPage(pageIndex - 1);
                        setState(() {});
                      },
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColors.greyColor,
                        size: SizeBlock.v! * 50,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                if (pageIndex != widget.shoes!.outfitsImages!.length - 1) Positioned.fill(
                  child: Align(
                    child: GestureDetector(
                      onTap: () {
                        pageController.jumpToPage(pageIndex + 1);
                        setState(() {});
                      },
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.greyColor,
                        size: SizeBlock.v! * 50,
                      ),
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
