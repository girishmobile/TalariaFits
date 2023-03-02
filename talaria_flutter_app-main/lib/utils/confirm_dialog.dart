import 'package:flutter/material.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/size_block.dart';
import 'package:talaria/utils/text_style.dart';

class ConfirmDialog {
  static showAlertDialog(BuildContext context, {required header, required message, required VoidCallback onConfirm, required VoidCallback onCancel}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel",
          style: AppTextStyle.openSansPurple().copyWith(fontSize: SizeBlock.v! * 16, fontWeight: FontWeight.w400)
      ),
      onPressed: () => onCancel(),
    );
    Widget continueButton = TextButton(
      child: Text("Continue",
          style: AppTextStyle.openSansPurple().copyWith(fontSize: SizeBlock.v! * 16, fontWeight: FontWeight.w400)
      ),
      onPressed:  () => onConfirm(),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: AppColors.whiteColor,
      title: Text(header,
          style: AppTextStyle.openSansPurple().copyWith(fontSize: SizeBlock.v! * 22, fontWeight: FontWeight.w600)
      ),
      content: Text(message,
          style: AppTextStyle.openSansPurple().copyWith(fontSize: SizeBlock.v! * 18, fontWeight: FontWeight.w400)
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  
}