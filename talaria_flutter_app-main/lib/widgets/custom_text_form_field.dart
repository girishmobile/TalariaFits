import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/size_block.dart';
import '../utils/text_style.dart';

class CustomTextFormField extends StatelessWidget {
  TextEditingController editingController;
  Function(String value) onChanged;
  String hintText;
  int maxLines;

  CustomTextFormField({required this.editingController, required this.hintText, required this.onChanged, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      controller: editingController,
      onChanged: (value) {
        onChanged(value);
      },
      cursorColor: AppColors.purpleTextColor,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.go,
      style: AppTextStyle.openSansPurple().copyWith(
          fontSize: SizeBlock.v! * 18,
          fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: AppColors.skinColor,
        filled: true,
        isDense: true,
        hintStyle: AppTextStyle.openSansPurple()
            .copyWith(
            fontSize: SizeBlock.v! * 18,
            fontWeight: FontWeight.w400),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
            BorderSide(color: AppColors.skinColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
            BorderSide(color: AppColors.skinColor)),
        errorBorder: null,
        focusedErrorBorder: null,
      ),
    );
  }

}