import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:talaria/models/shoes_model.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/loader.dart';
import 'package:talaria/utils/text_style.dart';
import '../../../utils/size_block.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import '../../../widgets/app_button.dart';
import '../../provider/individual_shoe_provider.dart';

class AdminIndividualShoesPage extends StatefulWidget {
  final ShoesDataModel shoesDataModel;

  const AdminIndividualShoesPage(
      {Key? key, required this.shoesDataModel})
      : super(key: key);

  @override
  _AdminIndividualShoesPageState createState() =>
      _AdminIndividualShoesPageState();
}

class _AdminIndividualShoesPageState
    extends State<AdminIndividualShoesPage> {

  String gender = "Men";

  @override
  void initState() {
    if (widget.shoesDataModel.genderType == 0) {
      gender = "Men";
    } else if (widget.shoesDataModel.genderType == 1) {
      gender = "Women";
    } else if (widget.shoesDataModel.genderType == 2) {
      gender = "Men & Women";
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Consumer<IndividualShoeProvider>(builder:
        (context, IndividualShoeProvider myIndividualShoeProvider, _) {
      return LoadingOverlay(
        isLoading: myIndividualShoeProvider.isLoading,
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
                                                .shoesDataModel.mainImage ?? "",
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
                              widget.shoesDataModel.name ?? "",
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
                              widget.shoesDataModel.description ?? "",
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
                              "${toBeginningOfSentenceCase(
                                  gender)}",
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
                              widget: Text("Delete Shoes",
                                  style: AppTextStyle.openSansPurple()
                                      .copyWith(fontSize: SizeBlock.v! * 18)),
                              onTap: () async {
                                myIndividualShoeProvider.removeShoes(context, widget.shoesDataModel);
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
