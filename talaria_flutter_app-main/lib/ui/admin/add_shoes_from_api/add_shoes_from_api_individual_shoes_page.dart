import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/models/sneaker_model.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/loader.dart';
import 'package:talaria/utils/text_style.dart';
import '../../../provider/add_shoes_from_api_provider.dart';
import '../../../utils/size_block.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import '../../../widgets/app_button.dart';

class AddShoesFromAPIIndividualShoesPage extends StatefulWidget {
  final APISneakerModel sneakerModel;

  const AddShoesFromAPIIndividualShoesPage(
      {Key? key, required this.sneakerModel})
      : super(key: key);

  @override
  _AddShoesFromAPIIndividualShoesPageState createState() =>
      _AddShoesFromAPIIndividualShoesPageState();
}

class _AddShoesFromAPIIndividualShoesPageState
    extends State<AddShoesFromAPIIndividualShoesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddShoesFromAPIProvider>(builder:
        (context, AddShoesFromAPIProvider myAddShoesFromAPIProvider, _) {
      return LoadingOverlay(
        isLoading: myAddShoesFromAPIProvider.isLoading,
        progressIndicator: Loader(),
        child: Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back_ios_rounded,
                    color: AppColors.blackColor, size: SizeBlock.v! * 30),
              ),
              title: Text(
                "Details",
                style: AppTextStyle.openSansSemiBold().copyWith(
                    fontSize: SizeBlock.v! * 30,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackColor),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: AppColors.whiteColor,
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            expandedHeight: SizeBlock.v! * 235,
                            floating: false,
                            //pinned: true,
                            leading: const SizedBox(),
                            backgroundColor: Colors.transparent,
                            flexibleSpace: FlexibleSpaceBar(
                              collapseMode: CollapseMode.parallax,
                              background: SizedBox(
                                  child: Container(
                                      padding: const EdgeInsets.only(bottom: 0),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(SizeBlock.v! * 10),
                                          child: CachedNetworkImage(
                                            imageUrl: widget
                                                .sneakerModel.image.original,
                                            fit: BoxFit.cover,
                                            errorWidget: (error, _, __) =>
                                                Center(
                                                    child: Text(
                                              "Image Missing",
                                              style:
                                                  AppTextStyle.openSansPurple()
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize:
                                                              SizeBlock.v! * 16,
                                                          color: Colors.grey),
                                            )),
                                          ),
                                        ),
                                      ))),
                            ),
                          ),
                        ];
                      },
                      body: Container(
                        width: Get.width,
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: ListView(
                          padding:
                              EdgeInsets.symmetric(vertical: SizeBlock.v! * 15),
                          children: [
                            Text(
                              widget.sneakerModel.name,
                              style: AppTextStyle.openSansPurple().copyWith(
                                  fontSize: SizeBlock.v! * 30,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: SizeBlock.v! * 10,
                            ),
                            Text(
                              "Description",
                              style: AppTextStyle.openSansPurple().copyWith(
                                  fontSize: SizeBlock.v! * 25,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.goldenColor),
                            ),
                            Divider(
                              color: AppColors.themeColor,
                              thickness: SizeBlock.v! * 1,
                            ),
                            SizedBox(
                              height: SizeBlock.v! * 10,
                            ),
                            Text(
                              widget.sneakerModel.story,
                              style: AppTextStyle.openSansPurple().copyWith(
                                  fontSize: SizeBlock.v! * 20,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: SizeBlock.v! * 10,
                            ),
                            Text(
                              "Colorway",
                              style: AppTextStyle.openSansPurple().copyWith(
                                  fontSize: SizeBlock.v! * 25,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.goldenColor),
                            ),
                            Divider(
                              color: AppColors.themeColor,
                              thickness: SizeBlock.v! * 1,
                            ),
                            SizedBox(
                              height: SizeBlock.v! * 10,
                            ),
                            Text(
                              widget.sneakerModel.colorway,
                              style: AppTextStyle.openSansPurple().copyWith(
                                  fontSize: SizeBlock.v! * 20,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: SizeBlock.v! * 10,
                            ),
                            Text(
                              "Gender",
                              style: AppTextStyle.openSansPurple().copyWith(
                                  fontSize: SizeBlock.v! * 25,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.goldenColor),
                            ),
                            Divider(
                              color: AppColors.themeColor,
                              thickness: SizeBlock.v! * 1,
                            ),
                            SizedBox(
                              height: SizeBlock.v! * 10,
                            ),
                            Text(
                              "${toBeginningOfSentenceCase(widget.sneakerModel.gender)}",
                              style: AppTextStyle.openSansPurple().copyWith(
                                  fontSize: SizeBlock.v! * 20,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: SizeBlock.v! * 10,
                            ),
                            Divider(
                              color: AppColors.themeColor,
                              thickness: SizeBlock.v! * 1,
                            ),
                            SizedBox(
                              height: SizeBlock.v! * 10,
                            ),
                            AppButtonWidget(
                              widget: Text("Add Shoes To My Database",
                                  style: AppTextStyle.openSansPurple()
                                      .copyWith(fontSize: SizeBlock.v! * 18)),
                              onTap: () async {
                                print("ADDING SHOES");
                                myAddShoesFromAPIProvider
                                    .addShoeToFirebaseFirestore(
                                        widget.sneakerModel);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      );
    });
  }
}
