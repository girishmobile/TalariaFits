import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:talaria/models/sneaker_model.dart';
import 'package:talaria/provider/add_shoes_from_api_provider.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/loader.dart';
import 'package:talaria/utils/size_block.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/widgets/home_screen_widgets/new_arrival_widget.dart';
import 'package:talaria/widgets/sneaker_shoes_widgets/sneaker_shoes_widget.dart';

class SneakerHomeScreen extends StatefulWidget {
  const SneakerHomeScreen({Key? key}) : super(key: key);

  @override
  State<SneakerHomeScreen> createState() => _SneakerHomeScreenState();
}

class _SneakerHomeScreenState extends State<SneakerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddShoesFromAPIProvider>(
        builder: (context, mySneakerProvider, _) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: LoadingOverlay(
            color: AppColors.whiteColor,
            isLoading: mySneakerProvider.isLoading,
            progressIndicator: Loader(),
            child: RefreshIndicator(
                color: AppColors.whiteColor,
                backgroundColor: AppColors.goldenColor,
                onRefresh: () async {},
                child: ListView(
                  padding: EdgeInsets.only(
                      bottom: SizeBlock.v! * 100,
                      left: SizeBlock.h! * 2,
                      right: SizeBlock.h! * 2),
                  children: [
                    Text(
                      "Sneaker record from API",
                      style: AppTextStyle.openSansSemiBold().copyWith(
                          fontSize: SizeBlock.v! * 24,
                          fontWeight: FontWeight.w600),
                    ),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: List.generate(
                          mySneakerProvider.sneakerListToDisplay.length,
                          (index) {
                        APISneakerModel sneakerShoes =
                            mySneakerProvider.sneakerListToDisplay[index];

                        return SneakerNewArrivalWidget(
                            provider: mySneakerProvider,
                            sneakerShoes: sneakerShoes);
                      }),
                    )
                  ],
                ))),
      );
    });
  }
}
