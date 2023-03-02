import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:talaria/utils/confirm_dialog.dart';
import 'package:talaria/utils/size_block.dart';
import '../../provider/admin_provider.dart';
import '../../utils/colors.dart';
import '../../utils/text_style.dart';

class SelectedColorWidget extends StatelessWidget {
  String colorName;

  SelectedColorWidget(this.colorName);

  late AdminProvider _adminProvider;

  @override
  Widget build(BuildContext context) {
    _adminProvider =
        Provider.of<AdminProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        ConfirmDialog.showAlertDialog(context,
            header: "Please confirm action",
            message: "Are you sure you want to remove \"$colorName\"",
            onConfirm: () {
              _adminProvider.removeColor(colorName);
          Navigator.pop(context);
        }, onCancel: () {
          Navigator.pop(context);
        });
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
              border: Border.all(color: AppColors.themeColor),
            ),
            child: FittedBox(
              child: Text(
                colorName,
                style: AppTextStyle.openSansPurple().copyWith(
                    fontSize: SizeBlock.v! * 12, color: AppColors.themeColor),
              ),
            ),
          );
        },
      ),
    );
  }
}
