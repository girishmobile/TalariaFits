import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:talaria/utils/size_block.dart';
import '../../provider/admin_provider.dart';
import '../../utils/colors.dart';
import '../../utils/text_style.dart';

class GenderWidget extends StatelessWidget {
  int genderId;
  String genderName;

  GenderWidget({required this.genderId, required this.genderName});

  late AdminProvider _adminProvider;

  @override
  Widget build(BuildContext context) {
    _adminProvider = Provider.of<AdminProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        _adminProvider.genderClicked(genderId);
      },
      child: Consumer<AdminProvider>(
        builder: (BuildContext context, AdminProvider myAdminProvider,
            Widget? child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.whiteColor,
              border: Border.all(
                  color: (myAdminProvider.selectedGenderType == genderId)
                      ? AppColors.themeColor
                      : AppColors.goldenColor),
            ),
            child: FittedBox(
              child: Text(
                genderName,
                style: AppTextStyle.openSansPurple().copyWith(
                    fontSize: SizeBlock.v! * 18,
                    color: (myAdminProvider.selectedGenderType == genderId)
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
