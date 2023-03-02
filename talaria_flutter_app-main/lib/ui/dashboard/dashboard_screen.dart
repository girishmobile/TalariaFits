import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/models/brands_model.dart';
import 'package:talaria/models/gender_type_model.dart';
import 'package:talaria/provider/add_shoes_from_api_provider.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/ui/admin/admin_home_page.dart';
import 'package:talaria/ui/dashboard/closet_screen.dart';
import 'package:talaria/ui/dashboard/favorite_screen.dart';
import 'package:talaria/ui/dashboard/home_screen.dart';
import 'package:talaria/ui/dashboard/search_screen.dart';
import 'package:talaria/ui/dashboard/settings/settings_screen.dart';
import 'package:talaria/ui/dashboard/sneaker_home_screen.dart';
import 'package:talaria/ui/dashboard/view_all_screen.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/images.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/widgets/app_button.dart';
import 'package:talaria/widgets/navigation_wrapper_widgets/custom_app_bar.dart';
import '../../provider/auth_provider.dart';
import '../../utils/size_block.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController pageController = PageController();

  int pageIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      dashboardProvider.onInit();
      dashboardProvider.emailNotifications =
          dashboardProvider.userData.isEmailEnabled!;
      dashboardProvider.pushNotifications =
          dashboardProvider.userData.isNotificationEnabled!;
      var sneakerProvider =
          Provider.of<AddShoesFromAPIProvider>(context, listen: false);
      sneakerProvider.getSneakersListByBrand('Jordan');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, DashboardProvider>(
        builder: (context, myAuthenticationProvider, myDashboardProvider, _) {
      return Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.whiteColor,
        appBar: CustomAppBar(
          height: SizeBlock.v! * 160,
          leadingWith: Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Image.asset(
                  AppImages.menu,
                  scale: 3,
                ),
              );
            },
          ),
          endingWith: Image.asset(
            AppImages.menu,
            color: Colors.transparent,
            scale: 3,
          ),
        ),
        drawer: (myAuthenticationProvider.isLoading ||
                myDashboardProvider.isLoading)
            ? Container()
            : drawer(),
        body: Padding(
          padding: EdgeInsets.only(
            left: SizeBlock.h! * 20,
            right: SizeBlock.h! * 20,
          ),
          child: PageView(
            controller: pageController,
            onPageChanged: (val) {
              pageIndex = val;
              setState(() {});
            },
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomeScreen(),
              // SneakerHomeScreen(),
              FavoriteScreen(),
              SearchScreen(),
              ClosetScreen(),
              SettingsScreen()
            ],
          ),
        ),
        bottomNavigationBar: Container(
          width: Get.width,
          height: SizeBlock.v! * 90,
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1.5,
                  blurRadius: 3,
                  offset: const Offset(0, -0.5), // changes position of shadow
                ),
              ],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.elliptical(300, 50))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  pageIndex = 0;
                  pageController.jumpToPage(pageIndex);
                  setState(() {});
                },
                child: Image.asset(
                  AppImages.home,
                  scale: 5,
                  color: pageIndex == 0
                      ? AppColors.goldenColor
                      : AppColors.blackColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  pageIndex = 1;
                  pageController.jumpToPage(pageIndex);
                  setState(() {});
                },
                child: Image.asset(
                  AppImages.heart,
                  scale: 5,
                  color: pageIndex == 1
                      ? AppColors.goldenColor
                      : AppColors.blackColor,
                ),
              ),
              SizedBox(
                width: SizeBlock.h! * 5,
              ),
              GestureDetector(
                onTap: () {
                  pageIndex = 3;
                  pageController.jumpToPage(pageIndex);
                  setState(() {});
                },
                child: Image.asset(
                  AppImages.closet,
                  scale: 5,
                  color: pageIndex == 3
                      ? AppColors.goldenColor
                      : AppColors.blackColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  pageIndex = 4;
                  pageController.jumpToPage(pageIndex);
                  setState(() {});
                },
                child: Image.asset(
                  AppImages.user,
                  scale: 5,
                  color: pageIndex == 4
                      ? AppColors.goldenColor
                      : AppColors.blackColor,
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          padding: EdgeInsets.only(top: SizeBlock.v! * 0),
          width: SizeBlock.h! * 85,
          height: SizeBlock.h! * 85,
          color: Colors.transparent,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              pageIndex = 2;
              pageController.jumpToPage(pageIndex);
              setState(() {});
            },
            child: Image.asset(
              AppImages.search,
              scale: 4,
              color: pageIndex == 2
                  ? AppColors.goldenColor
                  : AppColors.goldenColor,
            ),
          ),
        ),
      );
    });
  }

  Widget drawer() {
    GenderTypeModel? shoesValue;
    BrandsModel? brandValue;
    return Drawer(
      child: Consumer2<AuthProvider, DashboardProvider>(
        builder: (BuildContext context, AuthProvider myAuthProvider,
            DashboardProvider myDashboardProvider, Widget? child) {
          return Container(
            width: Get.width,
            height: Get.height,
            padding: const EdgeInsets.all(10),
            color: AppColors.whiteColor,
            child: Column(
              children: [
                SizedBox(
                  height: 3.h,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: AppColors.blackColor),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Image.asset(
                  AppImages.logo,
                  scale: 5,
                ),
                SizedBox(
                  height: 2.h,
                ),
                DropdownButtonHideUnderline(
                  child: Container(
                    width: Get.width,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.themeColor),
                        color: AppColors.whiteColor),
                    child: (myDashboardProvider.genderList.isNotEmpty)
                        ? DropdownButton<GenderTypeModel>(
                            isExpanded: true,
                            value: shoesValue,
                            dropdownColor: AppColors.whiteColor,
                            isDense: true,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.purpleTextColor,
                            ),
                            elevation: 16,
                            hint: Text(
                              "All Genders",
                              style: AppTextStyle.openSansSemiBold()
                                  .copyWith(fontSize: 14.sp),
                            ),
                            style: AppTextStyle.openSansSemiBold()
                                .copyWith(fontSize: 14.sp),
                            onChanged: (GenderTypeModel? newValue) {
                              setState(() {
                                shoesValue = newValue;
                              });
                              Navigator.of(context).pop();
                              if (shoesValue!.name == "Male") {
                                Get.to(() => ViewAllScreen(
                                      heading: shoesValue?.name ?? "",
                                      shoesList: myDashboardProvider
                                          .getListByGender(0),
                                    ));
                              } else if (shoesValue!.name == "Female") {
                                Get.to(() => ViewAllScreen(
                                      heading: shoesValue?.name ?? "",
                                      shoesList: myDashboardProvider
                                          .getListByGender(1),
                                    ));
                              } else if (shoesValue!.name == "Male & Female") {
                                Get.to(() => ViewAllScreen(
                                      heading: shoesValue?.name ?? "",
                                      shoesList: myDashboardProvider
                                          .getListByGender(2),
                                    ));
                              } else {
                                Get.to(() => ViewAllScreen(
                                      heading: shoesValue!.name,
                                      shoesList: myDashboardProvider
                                          .getListByGender(2),
                                    ));
                              }
                            },
                            items: myDashboardProvider.genderList
                                .map<DropdownMenuItem<GenderTypeModel>>(
                                    (GenderTypeModel value) {
                              return DropdownMenuItem<GenderTypeModel>(
                                value: value,
                                child: Text(
                                  value.name!,
                                  style: AppTextStyle.openSansSemiBold()
                                      .copyWith(fontSize: 14.sp),
                                ),
                              );
                            }).toList(),
                          )
                        : Container(),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: Container(
                    width: Get.width,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.themeColor),
                        color: AppColors.whiteColor),
                    child: (myDashboardProvider.brandList.isNotEmpty)
                        ? DropdownButton<BrandsModel>(
                            isExpanded: true,
                            value: brandValue,
                            dropdownColor: AppColors.whiteColor,
                            isDense: true,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.purpleTextColor,
                            ),
                            elevation: 16,
                            hint: Text(
                              "All Brands",
                              style: AppTextStyle.openSansSemiBold()
                                  .copyWith(fontSize: 14.sp),
                            ),
                            style: AppTextStyle.openSansSemiBold()
                                .copyWith(fontSize: 14.sp),
                            onChanged: (BrandsModel? newValue) {
                              setState(() {
                                brandValue = newValue!;
                              });
                              Navigator.of(context).pop();
                              Get.to(() => ViewAllScreen(
                                  heading: brandValue?.name ?? "",
                                  shoesList: myDashboardProvider
                                      .getListByBrand(brandValue?.name ?? "")));
                            },
                            items: myDashboardProvider.brandList
                                .map<DropdownMenuItem<BrandsModel>>(
                                    (BrandsModel value) {
                              return DropdownMenuItem<BrandsModel>(
                                value: value,
                                child: Text(
                                  value.name!,
                                  style: AppTextStyle.openSansSemiBold()
                                      .copyWith(fontSize: 14.sp),
                                ),
                              );
                            }).toList(),
                          )
                        : Container(),
                  ),
                ),
                //IF USER IS AN ADMIN, THEN ADD ADMIN BUTTON
                if (myAuthProvider.userData.role == 2)
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    width: Get.width,
                    child: AppButtonWidget(
                      widget: Text("GO TO ADMIN PANEL",
                          style: AppTextStyle.openSansPurple()
                              .copyWith(fontSize: SizeBlock.v! * 18)),
                      onTap: () {
                        Get.to(() => AdminHomePage());
                      },
                    ),
                  ),
                Container(
                  width: Get.width,
                  margin: const EdgeInsets.fromLTRB(10, 100, 10, 0),
                  child: AppButtonWidget(
                    widget: Text("Log Out",
                        style: AppTextStyle.openSansPurple()
                            .copyWith(fontSize: SizeBlock.v! * 18)),
                    onTap: () {
                      myAuthProvider.logoutUser(context);
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
