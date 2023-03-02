import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talaria/models/shoes_model.dart';
import 'package:talaria/ui/dashboard/product_detail_screen.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/text_style.dart';

import '../utils/size_block.dart';

class ProductWidget extends StatefulWidget {
  final ShoesDataModel? shoes;

  const ProductWidget({Key? key, this.shoes}) : super(key: key);
  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: GestureDetector(
        onTap: () {
          Get.to(() => ProductDetailScreen(
                shoes: widget.shoes,
              ));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  width: SizeBlock.h! * 166,
                  height: SizeBlock.v! * 123,
                  decoration: BoxDecoration(
                    color: AppColors.goldenColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(1, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: widget.shoes?.mainImage ?? "",
                      fit: BoxFit.cover,
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeBlock.h! * 10),
              child: Text(
                widget.shoes!.name ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.openSansSemiBold(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeBlock.h! * 10),
                child: Text(
                  widget.shoes?.description ?? "",
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.openSansPurple().copyWith(fontWeight: FontWeight.w400, fontSize: SizeBlock.v! * 14),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
