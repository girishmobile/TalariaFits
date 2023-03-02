import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/provider/admin_provider.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/utils/confirm_dialog.dart';
import '../../utils/colors.dart';
import '../../utils/loader.dart';
import '../../utils/size_block.dart';
import '../../utils/text_style.dart';
import '../../widgets/admin_widgets/brand_widget.dart';
import '../../widgets/app_button.dart';
import '../../widgets/navigation_wrapper_widgets/custom_app_bar.dart';

class EditBrandsPage extends StatefulWidget {
  @override
  State<EditBrandsPage> createState() => _EditBrandsPageState();
}

class _EditBrandsPageState extends State<EditBrandsPage> {
  TextEditingController _brandController = TextEditingController();
  late AdminProvider _adminProvider;

  @override
  void initState() {
    _adminProvider = Provider.of<AdminProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder:
          (BuildContext context, AdminProvider myAdminProvider, Widget? child) {
        return LoadingOverlay(
          isLoading: myAdminProvider.isLoading,
          progressIndicator: Loader(),
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
                resizeToAvoidBottomInset: false,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeBlock.h! * 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Brands",
                        style: AppTextStyle.openSansSemiBold().copyWith(
                            color: AppColors.goldenColor,
                            fontSize: SizeBlock.v! * 22,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: SizeBlock.v! * 10,
                      ),
                      TextFormField(
                        controller: _brandController,
                        cursorColor: AppColors.purpleTextColor,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        style: AppTextStyle.openSansPurple().copyWith(
                            fontSize: SizeBlock.v! * 18,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          hintText: "New Brand",
                          fillColor: AppColors.skinColor,
                          filled: true,
                          isDense: true,
                          hintStyle: AppTextStyle.openSansPurple()
                              .copyWith(
                                  fontSize: SizeBlock.v! * 18,
                                  fontWeight: FontWeight.w400)
                              .copyWith(
                                  fontSize: 10.sp,
                                  color: AppColors.purpleTextColor),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: AppColors.skinColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: AppColors.skinColor)),
                          errorBorder: null,
                          focusedErrorBorder: null,
                        ),
                      ),
                      SizedBox(
                        height: SizeBlock.v! * 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: AppButtonWidget(
                          widget: Text("Add Brand",
                              style: AppTextStyle.openSansPurple()
                                  .copyWith(fontSize: SizeBlock.v! * 18)),
                          onTap: () async {
                            int verifyResult = await _adminProvider
                                .verifyBrand(_brandController.text.trim());
                            if (verifyResult == 0) {
                              await _adminProvider.addBrand(
                                  context, _brandController.text.trim());
                              _brandController.text = "";
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: SizeBlock.v! * 10,
                      ),
                      Expanded(
                        child: Consumer<DashboardProvider>(
                          builder: (BuildContext context,
                              DashboardProvider myDashboardProvider,
                              Widget? child) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: myDashboardProvider.brandList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return BrandWidget(
                                      heading: myDashboardProvider
                                          .brandList[index].name!,
                                      onTap: () {
                                        ConfirmDialog.showAlertDialog(context,
                                            header: "Please Confirm",
                                            message:
                                                "Are you sure you want to remove this brand?",
                                            onConfirm: () {
                                          _adminProvider.removeBrand(
                                              context,
                                              myDashboardProvider
                                                  .brandList[index]);
                                        }, onCancel: () {
                                          Navigator.pop(context);
                                        });
                                      });
                                });
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
