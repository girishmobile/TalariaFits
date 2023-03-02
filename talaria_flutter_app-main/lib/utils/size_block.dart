import 'package:flutter/widgets.dart';

/// this class is used to set the dimensions of the widgets according
/// to their precise sizes from designs
class SizeBlock {
  final double limitValue = 0.77;

  //h == horizontal
  static double? h;

  //v == vertical
  static double? v;
  static double? vMin;

  void init(BuildContext context) {
    h = MediaQuery.of(context).size.width / 428;
    v = MediaQuery.of(context).size.height / 926;
    print('h value: $h');

    vMin = v;
    if (h! < limitValue) h = limitValue;
    if (v! < limitValue) {
      v = limitValue;
      vMin = v! - 0.11;
    }
  }
}
