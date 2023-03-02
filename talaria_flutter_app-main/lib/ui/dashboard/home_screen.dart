import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/models/shoes_model.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/ui/dashboard/view_all_screen.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/text_style.dart';
import '../../utils/loader.dart';
import '../../utils/size_block.dart';
import '../../widgets/home_screen_widgets/new_arrival_widget.dart';
import '../../widgets/home_screen_widgets/most_popular_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
        builder: (context, myDashboardProvider, _) {
      return Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: LoadingOverlay(
            isLoading: myDashboardProvider.isLoading,
            progressIndicator: Loader(),
            child: RefreshIndicator(
              color: AppColors.whiteColor,
              backgroundColor: AppColors.goldenColor,
              onRefresh: () async {
                await myDashboardProvider.onRefresh();
              },
              child: ListView(
                padding: EdgeInsets.only(
                    bottom: SizeBlock.v! * 120,
                    left: SizeBlock.h! * 2,
                    right: SizeBlock.h! * 2),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Most Popular",
                        style: AppTextStyle.openSansSemiBold().copyWith(
                            fontSize: SizeBlock.v! * 24,
                            fontWeight: FontWeight.w600),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ViewAllScreen(
                                heading: "Most Popular",
                                shoesList:
                                    myDashboardProvider.getTopRatingShoes(),
                              ));
                        },
                        child: Text(
                          "View All",
                          style: AppTextStyle.openSansSemiBold()
                              .copyWith(
                                  fontSize: SizeBlock.v! * 14,
                                  fontWeight: FontWeight.w600)
                              .copyWith(fontSize: 10.sp),
                        ),
                      ),
                    ],
                  ),
                  if (myDashboardProvider.getTopRatingShoes().isNotEmpty)
                    MostPopularWidget(
                        provider: myDashboardProvider,
                        shoeData:
                            myDashboardProvider.getTopRatingShoes().first),
                  Text(
                    "New Arrivals",
                    style: AppTextStyle.openSansSemiBold().copyWith(
                        fontSize: SizeBlock.v! * 24,
                        fontWeight: FontWeight.w600),
                  ),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: List.generate(myDashboardProvider.shoeList.length,
                        (index) {
                      ShoesDataModel shoes =
                          myDashboardProvider.shoeList[index];
                      return NewArrivalWidget(
                        provider: myDashboardProvider,
                        shoeData: shoes,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
