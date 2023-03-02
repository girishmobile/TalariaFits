import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/provider/individual_shoe_provider.dart';
import 'package:talaria/provider/search_provider.dart';
import 'package:talaria/constants/constants.dart';
import 'package:talaria/widgets/admin_widgets/individual_shoes_widgets/selected_color_individual_shoes.dart';
import '../../models/brands_model.dart';
import '../../models/shoes_model.dart';
import '../../utils/colors.dart';
import '../../utils/loader.dart';
import '../../utils/size_block.dart';
import '../../utils/text_style.dart';
import '../../widgets/admin_widgets/individual_shoes_widgets/gender_individual_shoes_widget.dart';
import '../../widgets/admin_widgets/individual_shoes_widgets/images_row_edit_shoe.dart';
import '../../widgets/admin_widgets/individual_shoes_widgets/shoe_size_individual_shoe_widget.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/navigation_wrapper_widgets/custom_app_bar.dart';

class AdminIndividualShoePage extends StatefulWidget {
  ShoesDataModel shoesDataModel;

  AdminIndividualShoePage({required this.shoesDataModel});

  @override
  State<AdminIndividualShoePage> createState() => _AdminIndividualShoePageState();
}

class _AdminIndividualShoePageState extends State<AdminIndividualShoePage> {
  final TextEditingController _colorController = TextEditingController();
  late IndividualShoeProvider _individualShoeProvider;
  late SearchProvider _searchProvider;

  @override
  void initState() {
    Future.delayed(Duration.zero, (){
      _individualShoeProvider = Provider.of<IndividualShoeProvider>(context, listen: false);
      _searchProvider = Provider.of<SearchProvider>(context, listen: false);
      _individualShoeProvider.fillIndividualShoesPageFields(shoesDataModel: widget.shoesDataModel);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IndividualShoeProvider>(
      builder:
          (BuildContext context, IndividualShoeProvider myIndividualShoeProvider, Widget? child) {
        return LoadingOverlay(
          isLoading: myIndividualShoeProvider.isLoading,
          progressIndicator: Loader(),
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: AppColors.whiteColor,
                appBar: CustomAppBar(
                  leadingWith: Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                          onTap: () {
                            Get.back();
                            _individualShoeProvider.clearEditShoesPage();
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
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeBlock.h! * 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add Shoes",
                        style: AppTextStyle.openSansSemiBold().copyWith(
                            color: AppColors.goldenColor,
                            fontSize: SizeBlock.v! * 22,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: SizeBlock.v! * 10,
                      ),
                      Expanded(
                        child: Consumer<DashboardProvider>(
                          builder: (BuildContext context,
                              DashboardProvider myDashboardProvider,
                              Widget? child) {
                            return Consumer<IndividualShoeProvider>(
                              builder: (BuildContext context,
                                  IndividualShoeProvider myIndividualShoeProvider,
                                  Widget? child) {
                                return SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                      bottom: SizeBlock.v! * 30),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    // shrinkWrap: true,
                                    // padding: EdgeInsets.only(bottom: SizeBlock.v! * 45),
                                    children: [
                                      DropdownButtonHideUnderline(
                                        child: Container(
                                          width: Get.width,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: AppColors.themeColor),
                                              color: AppColors.whiteColor),
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: (myDashboardProvider
                                                .brandList.isNotEmpty &&
                                                myIndividualShoeProvider
                                                    .selectedBrand.isEmpty)
                                                ? myDashboardProvider
                                                .brandList.first.name!
                                                : (myDashboardProvider.brandList
                                                .isNotEmpty &&
                                                myIndividualShoeProvider
                                                    .selectedBrand
                                                    .isNotEmpty)
                                                ? myIndividualShoeProvider
                                                .selectedBrand
                                                : "",
                                            dropdownColor: AppColors.whiteColor,
                                            isDense: true,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: AppColors.purpleTextColor,
                                            ),
                                            elevation: 16,
                                            hint: Text(
                                              "Select Brands",
                                              style: AppTextStyle
                                                  .openSansSemiBold()
                                                  .copyWith(fontSize: 14.sp),
                                            ),
                                            style:
                                            AppTextStyle.openSansSemiBold()
                                                .copyWith(fontSize: 14.sp),
                                            onChanged: (String? newValue) {
                                              _individualShoeProvider
                                                  .updateSelectedBrand(
                                                  newValue!);
                                            },
                                            items: myDashboardProvider.brandList
                                                .map<DropdownMenuItem<String>>(
                                                    (BrandsModel brandsModel) {
                                                  return DropdownMenuItem<String>(
                                                    value: brandsModel.name,
                                                    child: Text(
                                                      brandsModel.name ?? "",
                                                      overflow: TextOverflow.clip,
                                                      style: AppTextStyle
                                                          .openSansSemiBold()
                                                          .copyWith(
                                                          fontSize: 14.sp),
                                                    ),
                                                  );
                                                }).toList(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeBlock.v! * 10,
                                      ),
                                      CustomTextFormField(
                                        onChanged: (String value) {
                                          _individualShoeProvider
                                              .updateSelectedModelName(value);
                                        },
                                        hintText: 'Model Name',
                                        editingController: myIndividualShoeProvider.modelNameController,
                                      ),
                                      SizedBox(
                                        height: SizeBlock.v! * 10,
                                      ),
                                      CustomTextFormField(
                                        maxLines: 4,
                                        onChanged: (String value) {
                                          _individualShoeProvider
                                              .updateDescription(value);
                                        },
                                        hintText: 'Description',
                                        editingController:
                                        myIndividualShoeProvider.descriptionController,
                                      ),
                                      SizedBox(
                                        height: SizeBlock.v! * 25,
                                      ),
                                      Text(
                                        "Select Gender",
                                        style: AppTextStyle.openSansPurple()
                                            .copyWith(
                                            fontSize: SizeBlock.v! * 22,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Divider(
                                        color: AppColors.purpleTextColor,
                                        thickness: SizeBlock.v! * 1,
                                      ),
                                      Row(
                                        children: [
                                          GenderIndividualShoesWidget(
                                            genderName: 'Male',
                                            genderId: 0,
                                          ),
                                          GenderIndividualShoesWidget(
                                            genderName: 'Female',
                                            genderId: 1,
                                          ),
                                          GenderIndividualShoesWidget(
                                            genderName: 'Male & Female',
                                            genderId: 2,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: SizeBlock.v! * 25,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Select Sizes",
                                            style: AppTextStyle.openSansPurple()
                                                .copyWith(
                                                fontSize: SizeBlock.v! * 22,
                                                fontWeight:
                                                FontWeight.w400),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _individualShoeProvider.selectAllSizes();
                                            },
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Select All",
                                                style: AppTextStyle
                                                    .openSansPurple()
                                                    .copyWith(
                                                    fontSize:
                                                    SizeBlock.v! * 18,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Divider(
                                        color: AppColors.purpleTextColor,
                                        thickness: SizeBlock.v! * 1,
                                      ),
                                      GridView.count(
                                        physics:
                                        const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        childAspectRatio: 1,
                                        crossAxisCount: 8,
                                        crossAxisSpacing: SizeBlock.h! * 2,
                                        mainAxisSpacing: SizeBlock.v! * 5,
                                        shrinkWrap: true,
                                        children: List.generate(
                                            AppConstants.shoeSizes.length,
                                                (index) {
                                              return ShoeSizeIndividualShoesWidget(
                                                  AppConstants.shoeSizes[index]);
                                            }),
                                      ),
                                      SizedBox(
                                        height: SizeBlock.v! * 25,
                                      ),
                                      Text(
                                        "Main Image",
                                        style: AppTextStyle.openSansPurple()
                                            .copyWith(
                                            fontSize: SizeBlock.v! * 22,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Divider(
                                        color: AppColors.purpleTextColor,
                                        thickness: SizeBlock.v! * 1,
                                      ),
                                      (myIndividualShoeProvider.selectedMainImage != null) ?
                                        Container(
                                          height: SizeBlock.v! * 100,
                                          width: SizeBlock.v! * 100,
                                          margin: EdgeInsets.only(
                                              right: SizeBlock.h! * 10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors
                                                      .purpleTextColor)),
                                          child: Image.file(
                                            myIndividualShoeProvider.selectedMainImage!,
                                            fit: BoxFit.cover,
                                          ),
                                        ) : Container(
                                          height: SizeBlock.v! * 100,
                                          width: SizeBlock.v! * 100,
                                          margin: EdgeInsets.only(
                                              right: SizeBlock.h! * 10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors
                                                      .purpleTextColor)),
                                          child: CachedNetworkImage(
                                            imageUrl: myIndividualShoeProvider.mainImageURL,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      GestureDetector(
                                        onTap: () async {
                                          await _individualShoeProvider
                                              .getMainImageFromGallery();
                                        },
                                        child: Icon(
                                          Icons.add_circle_outline_outlined,
                                          color: AppColors.purpleTextColor,
                                          size: SizeBlock.v! * 60,
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeBlock.v! * 25,
                                      ),
                                      Text(
                                        "Select Colors",
                                        style: AppTextStyle.openSansPurple()
                                            .copyWith(
                                            fontSize: SizeBlock.v! * 22,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Divider(
                                        color: AppColors.purpleTextColor,
                                        thickness: SizeBlock.v! * 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                              onChanged: (String value) {},
                                              hintText: 'Enter a color name',
                                              editingController:
                                              _colorController,
                                            ),
                                          ),
                                          SizedBox(
                                            width: SizeBlock.h! * 10,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                _individualShoeProvider.addColor(
                                                    _colorController.text);
                                                _colorController.text = "";
                                                setState(() {});
                                              },
                                              child: Icon(
                                                Icons
                                                    .add_circle_outline_outlined,
                                                color:
                                                AppColors.purpleTextColor,
                                                size: SizeBlock.v! * 45,
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: SizeBlock.h! * 10,
                                      ),
                                      SizedBox(
                                        height: SizeBlock.v! * 30,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: myIndividualShoeProvider
                                              .selectedColors.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return SelectedColorWidgetIndividualShoes(
                                                myIndividualShoeProvider
                                                    .selectedColors[index]);
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeBlock.v! * 25,
                                      ),
                                      Text(
                                        "Shoe Images",
                                        style: AppTextStyle.openSansPurple()
                                            .copyWith(
                                            fontSize: SizeBlock.v! * 22,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Divider(
                                        color: AppColors.purpleTextColor,
                                        thickness: SizeBlock.v! * 1,
                                      ),
                                      SizedBox(
                                        height: SizeBlock.h! * 10,
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                        const NeverScrollableScrollPhysics(),
                                        itemCount: myIndividualShoeProvider
                                            .selectedColors.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ImagesRowEditShoesWidget(myIndividualShoeProvider
                                              .selectedColors[index]);
                                        },
                                      ),
                                      SizedBox(
                                        height: SizeBlock.h! * 10,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: AppButtonWidget(
                                          widget: Text("Submit Edited Data",
                                              style:
                                              AppTextStyle.openSansPurple()
                                                  .copyWith(
                                                  fontSize:
                                                  SizeBlock.v! *
                                                      18)),
                                          onTap: () async {
                                            int validationResult = _individualShoeProvider
                                                .validateShoesEditingInputs();
                                            if (validationResult == 0) {
                                              _individualShoeProvider
                                                  .updateShoes(context, widget.shoesDataModel);
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeBlock.h! * 10,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: AppButtonWidget(
                                          widget: Text("Delete Shoes",
                                              style:
                                              AppTextStyle.openSansPurple()
                                                  .copyWith(
                                                  fontSize:
                                                  SizeBlock.v! *
                                                      18)),
                                          onTap: () async {
                                            _individualShoeProvider
                                                  .removeShoes(context, widget.shoesDataModel);
                                            _searchProvider.removeShoeFromOriginalListToDisplay(widget.shoesDataModel);
                                            _searchProvider.removeShoeFromSearchListToDisplay(widget.shoesDataModel);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }
}
