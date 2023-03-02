import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/individual_shoe_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/size_block.dart';
import '../../../utils/text_style.dart';


class ImagesRowEditShoesWidget extends StatelessWidget {
  late IndividualShoeProvider _individualShoeProvider;
  String color;

  ImagesRowEditShoesWidget(this.color);

  @override
  Widget build(BuildContext context) {
    _individualShoeProvider = Provider.of<IndividualShoeProvider>(context, listen: false);
    return Row(
        children: [
      Text(
        color + ": ",
        style: AppTextStyle.openSansPurple()
            .copyWith(fontSize: SizeBlock.v! * 16, fontWeight: FontWeight.w400),
      ),
      Consumer<IndividualShoeProvider>(
        builder: (BuildContext context, IndividualShoeProvider myIndividualShoeProvider,
            Widget? child) {
          // return Container();
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: SizeBlock.v! * 10),
              height: SizeBlock.v! * 150,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: (myIndividualShoeProvider.selectedImages.containsKey(color))
                    ? myIndividualShoeProvider.selectedImages[color]!.length
                    : myIndividualShoeProvider.imagesURLs[color]!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: SizeBlock.v! * 100,
                      width: SizeBlock.v! * 100,
                      margin: EdgeInsets.only(right: SizeBlock.h! * 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.purpleTextColor)),
                      child: (myIndividualShoeProvider.selectedImages.containsKey(color))
                          ? Image.file(
                        myIndividualShoeProvider.selectedImages[color]![index],
                        fit: BoxFit.cover,
                      )
                          : CachedNetworkImage(
                        imageUrl:
                        myIndividualShoeProvider.imagesURLs[color]![index],
                        fit: BoxFit.cover,
                      ));
                },
              ),
            ),
          );
        },
      ),
      GestureDetector(
        onTap: () async {
          _individualShoeProvider.modifyColorImages(color);
          await _individualShoeProvider.getImagesFromGallery(color: color);
        },
        child: Icon(
          Icons.add_circle_outline_outlined,
          color: AppColors.purpleTextColor,
          size: SizeBlock.v! * 60,
        ),
      )
    ]);
  }
}
