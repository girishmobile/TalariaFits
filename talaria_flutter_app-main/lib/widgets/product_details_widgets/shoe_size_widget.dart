// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
//
// import '../../provider/product_detail_provider.dart';
//
// class ShoeSizeWidget extends StatelessWidget {
//   List<int> shoeSizes;
//   int index;
//
//   ShoeSizeWidget(this.shoeSizes);
//
//   ProductDetailProvider? _productDetailProvider;
//   @override
//   Widget build(BuildContext context) {
//     _productDetailProvider = Provider.of<ProductDetailProvider>(context, listen: false);
//     return GestureDetector(
//         onTap: () {
//           _productDetailProvider.updateSelectedShoeSize(newShoeSize: newShoeSize, newShoeSizeIndex: newShoeSizeIndex)
//           shoeSize = widget.shoes!.size![index].toString();
//           sizeIndex = index;
//           setState(() {});
//         },
//         child: Container(
//           padding: const EdgeInsets.all(7),
//           margin: const EdgeInsets.symmetric(horizontal: 3),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: AppColors.whiteColor,
//               border: Border.all(
//                   color: sizeIndex == index
//                       ? AppColors.themeColor
//                       : AppColors.goldenColor)),
//           child: FittedBox(
//             child: Text(
//               widget.shoes!.size![index].toString(),
//               style: AppTextStyle.openSansPurple().copyWith(
//                   fontSize: 12.sp,
//                   color: sizeIndex == index
//                       ? AppColors.themeColor
//                       : AppColors.goldenColor),
//             ),
//           ),
//         ),
//       );
//
//   }
//
// }