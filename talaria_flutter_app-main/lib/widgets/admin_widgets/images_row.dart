import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talaria/provider/admin_provider.dart';
import '../../utils/colors.dart';
import '../../utils/size_block.dart';
import '../../utils/text_style.dart';

class ImagesRowWidget extends StatelessWidget {
  late AdminProvider _adminProvider;
  String color;

  ImagesRowWidget(this.color);

  @override
  Widget build(BuildContext context) {
    _adminProvider = Provider.of<AdminProvider>(context, listen: false);
    return Row(children: [
      Text(
        color + ": ",
        style: AppTextStyle.openSansPurple()
            .copyWith(fontSize: SizeBlock.v! * 16, fontWeight: FontWeight.w400),
      ),
      Consumer<AdminProvider>(
        builder: (BuildContext context, AdminProvider myAdminProvider,
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
                itemCount: myAdminProvider.selectedImages[color]!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: SizeBlock.v! * 100,
                      width: SizeBlock.v! * 100,
                      margin: EdgeInsets.only(right: SizeBlock.h! * 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.purpleTextColor)),
                      child: Image.file(
                              myAdminProvider.selectedImages[color]![index],
                              fit: BoxFit.cover,
                            )
                          );
                },
              ),
            ),
          );
        },
      ),
      GestureDetector(
        onTap: () async {
          await _adminProvider.getImagesFromGallery(color: color);
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
