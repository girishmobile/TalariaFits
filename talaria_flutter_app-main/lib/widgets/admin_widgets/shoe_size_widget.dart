import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:talaria/utils/size_block.dart';
import '../../provider/admin_provider.dart';
import '../../utils/colors.dart';
import '../../utils/text_style.dart';

class ShoeSizeWidget extends StatelessWidget {
  double shoeSize;

  ShoeSizeWidget(this.shoeSize);

  late AdminProvider _adminProvider;

  @override
  Widget build(BuildContext context) {
    _adminProvider = Provider.of<AdminProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        _adminProvider.shoeSizeClicked(shoeSize);
      },
      child: Consumer<AdminProvider>(
        builder: (BuildContext context, AdminProvider myAdminProvider,
            Widget? child) {
          return Container(
            padding: const EdgeInsets.all(7),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.whiteColor,
                border: Border.all(
                    color: myAdminProvider.selectedSizes.contains(shoeSize)
                        ? AppColors.themeColor
                        : AppColors.goldenColor)),
            child: FittedBox(
              child: Text(
                  (shoeSize.toStringAsFixed(1).contains(".5")) ?
                shoeSize.toStringAsFixed(1) : shoeSize.toStringAsFixed(0),
                style: AppTextStyle.openSansPurple().copyWith(
                    fontSize: SizeBlock.v! * 12,
                    color: myAdminProvider.selectedSizes.contains(shoeSize)
                        ? AppColors.themeColor
                        : AppColors.goldenColor),
              ),
            ),
          );
        },
      ),
    );
  }
}
