import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:talaria/models/shoes_model.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/ui/dashboard/product_detail_screen.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/text_style.dart';
import '../../utils/size_block.dart';
import '../../widgets/navigation_wrapper_widgets/custom_app_bar.dart';
import '../../widgets/search_widgets/search_list_widget.dart';

class ViewAllScreen extends StatefulWidget {
  final String? heading;
  List<ShoesDataModel>? shoesList;
  ViewAllScreen({Key? key, this.heading, this.shoesList}) : super(key: key);

  @override
  _ViewAllScreenState createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomAppBar(
          leadingWith: Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: SizeBlock.v! * 30,
                    color: AppColors.blackColor,
                  ));
            },
          ),
          endingWith: Icon(
            Icons.arrow_back_ios_rounded,
            size: SizeBlock.v! * 30,
            color: Colors.transparent,
          ),
          height: SizeBlock.v! * 160,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: widget.shoesList!.isEmpty
              ? Center(
                  child: Text(
                  "No Products Found",
                  style: AppTextStyle.openSansPurple(),
                ))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.heading ?? "",
                      style: AppTextStyle.openSansSemiBold().copyWith(
                          color: AppColors.goldenColor,
                          fontSize: SizeBlock.v! * 22,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: SizeBlock.v! * 10,
                    ),
                    Expanded(
                      child: GridView.count(
                        scrollDirection: Axis.vertical,
                        childAspectRatio: 0.85,
                        crossAxisCount: 2,
                        crossAxisSpacing: SizeBlock.h! * 20,
                        mainAxisSpacing: SizeBlock.v! * 10,
                        shrinkWrap: true,
                        children: List.generate(widget.shoesList?.length ?? 0,
                            (index) {
                          return SearchListWidget(
                            shoes: widget.shoesList![index],
                            onTap: () {
                              Get.to(() => ProductDetailScreen(
                                    shoes: widget.shoesList![index],
                                  ));
                            },
                          );
                        }),
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
