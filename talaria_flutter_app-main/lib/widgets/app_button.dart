import 'package:flutter/material.dart';
import 'package:talaria/utils/colors.dart';

class AppButtonWidget extends StatefulWidget {
  final Widget? widget;
  final VoidCallback? onTap;
  final bool isDisabled;

  const AppButtonWidget({Key? key, this.widget, this.onTap, this.isDisabled = false}) : super(key: key);

  @override
  _AppButtonWidgetState createState() => _AppButtonWidgetState();
}

class _AppButtonWidgetState extends State<AppButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
        splashFactory: (widget.isDisabled) ? NoSplash.splashFactory : InkSplash.splashFactory,
        elevation: (widget.isDisabled) ? MaterialStateProperty.all(0) : MaterialStateProperty.all(5),
        backgroundColor: (widget.isDisabled) ? MaterialStateProperty.all(AppColors.greyColor) : MaterialStateProperty.all(AppColors.goldenColor),
      ),
      child: widget.widget,
      onPressed: (widget.isDisabled) ? () => {} : widget.onTap,
    );
  }
}
