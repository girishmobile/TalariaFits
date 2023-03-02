// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/text_style.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final int? maxLines;
  final bool? isPassword;
  final TextStyle? style;
  bool? showPassword;
  final bool? readOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  AppTextField(
      {Key? key,
      this.controller,
      this.validator,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.inputAction,
      this.inputType,
      this.maxLines = 1,
      this.showPassword = false,
      this.isPassword = false,
      this.readOnly = false,
      this.onChanged,
      this.onTap,
      this.style})
      : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      child: TextFormField(
        cursorColor: AppColors.goldenColor,
        keyboardType: widget.inputType,
        textInputAction: widget.inputAction,
        controller: widget.controller,
        validator: widget.validator,
        maxLines: widget.maxLines,
        readOnly: widget.readOnly!,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        style: widget.style,
        obscureText: widget.showPassword ?? false,
        decoration: InputDecoration(
          hintText: widget.hintText,
          fillColor: Colors.transparent,
          filled: true,
          isDense: true,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword!
              ? IconButton(
                  icon: Icon(widget.showPassword!
                      ? Icons.visibility
                      : Icons.visibility_off),
                  color: AppColors.goldenColor,
                  onPressed: () {
                    setState(() {
                      widget.showPassword = !widget.showPassword!;
                    });
                  },
                )
              : widget.suffixIcon,
          hintStyle: AppTextStyle.comfortaaBold().copyWith(fontSize: 10.sp),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.goldenColor)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.goldenColor)),
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.redColor)),
          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.redColor)),
        ),
      ),
    );
  }
}
