import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:talaria/utils/size_block.dart';
import '../../../provider/individual_shoe_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_style.dart';


class ShoeSizeIndividualShoesWidget extends StatelessWidget {
  double shoeSize;

  ShoeSizeIndividualShoesWidget(this.shoeSize);

  late IndividualShoeProvider _individualShoeProvider;

  @override
  Widget build(BuildContext context) {
    _individualShoeProvider = Provider.of<IndividualShoeProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        _individualShoeProvider.shoeSizeClicked(shoeSize);
      },
      child: Consumer<IndividualShoeProvider>(
        builder: (BuildContext context, IndividualShoeProvider myIndividualShoeProvider,
            Widget? child) {
          return Container(
            padding: const EdgeInsets.all(7),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.whiteColor,
                border: Border.all(
                    color: myIndividualShoeProvider.selectedSizes.contains(shoeSize)
                        ? AppColors.themeColor
                        : AppColors.goldenColor)),
            child: FittedBox(
              child: Text(
                (shoeSize.toStringAsFixed(1).contains(".5")) ?
                shoeSize.toStringAsFixed(1) : shoeSize.toStringAsFixed(0),
                style: AppTextStyle.openSansPurple().copyWith(
                    fontSize: SizeBlock.v! * 12,
                    color: myIndividualShoeProvider.selectedSizes.contains(shoeSize)
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
