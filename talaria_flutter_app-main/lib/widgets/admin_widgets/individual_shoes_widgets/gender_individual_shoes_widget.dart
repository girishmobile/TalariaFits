import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:talaria/provider/individual_shoe_provider.dart';
import 'package:talaria/utils/size_block.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_style.dart';


class GenderIndividualShoesWidget extends StatelessWidget {
  int genderId;
  String genderName;

  GenderIndividualShoesWidget({required this.genderId, required this.genderName});

  late IndividualShoeProvider _individualShoeProvider;
  @override
  Widget build(BuildContext context) {
    _individualShoeProvider = Provider.of<IndividualShoeProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        _individualShoeProvider.genderClicked(genderId);
      },
      child: Consumer<IndividualShoeProvider>(
        builder: (BuildContext context, IndividualShoeProvider myIndividualShoeProvider,
            Widget? child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.whiteColor,
              border: Border.all(
                  color: (myIndividualShoeProvider.selectedGenderType == genderId)
                      ? AppColors.themeColor
                      : AppColors.goldenColor),
            ),
            child: FittedBox(
              child: Text(
                genderName,
                style: AppTextStyle.openSansPurple().copyWith(
                    fontSize: SizeBlock.v! * 18,
                    color: (myIndividualShoeProvider.selectedGenderType == genderId)
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
