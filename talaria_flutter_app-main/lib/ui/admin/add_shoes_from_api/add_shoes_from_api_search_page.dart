import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/models/sneaker_model.dart';
import 'package:talaria/provider/add_shoes_from_api_provider.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/utils/loader.dart';
import 'package:talaria/widgets/admin_widgets/shoes_from_api_widget.dart';
import '../../../provider/search_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/size_block.dart';
import '../../../utils/text_style.dart';
import '../../../widgets/navigation_wrapper_widgets/custom_app_bar.dart';
import '../../../widgets/search_widgets/search_list_widget.dart';
import 'add_shoes_from_api_individual_shoes_page.dart';

class AddShoesFromAPISearchPage extends StatefulWidget {
  @override
  State<AddShoesFromAPISearchPage> createState() =>
      _AddShoesFromAPISearchPageState();
}

class _AddShoesFromAPISearchPageState extends State<AddShoesFromAPISearchPage> {
  TextEditingController searchController = TextEditingController();
  late AddShoesFromAPIProvider _addShoesFromAPIProvider;

  @override
  void initState() {
    _addShoesFromAPIProvider =
        Provider.of<AddShoesFromAPIProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomAppBar(
          leadingWith: Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                  onTap: () {
                    Get.back();
                    //clearing a previous array of sneakers and page displayed index
                    _addShoesFromAPIProvider.clearPageOutputs();
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
        body: Consumer<DashboardProvider>(builder: (context, provider, _) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeBlock.h! * 20),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            expandedHeight: SizeBlock.v! * 125,
                            floating: false,
                            //pinned: true,
                            leading: const SizedBox(),
                            backgroundColor: Colors.transparent,
                            flexibleSpace: FlexibleSpaceBar(
                              collapseMode: CollapseMode.parallax,
                              background: Column(
                                children: [
                                  TextFormField(
                                    controller: searchController,
                                    cursorColor: AppColors.purpleTextColor,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.search,
                                    onFieldSubmitted: (val) {
                                      //clearing a previous array of sneakers and page displayed index
                                      _addShoesFromAPIProvider.clearPageOutputs();
                                      //updating the list displayed
                                      _addShoesFromAPIProvider
                                          .populateShoesListToDisplayBySearchQuery(
                                              searchController.text);
                                    },
                                    style: AppTextStyle.openSansPurple()
                                        .copyWith(
                                            fontSize: SizeBlock.v! * 18,
                                            fontWeight: FontWeight.w400),
                                    decoration: InputDecoration(
                                      hintText: "Search",
                                      fillColor: AppColors.skinColor,
                                      filled: true,
                                      isDense: true,
                                      hintStyle: AppTextStyle.comfortaaBold()
                                          .copyWith(
                                              fontSize: 10.sp,
                                              color: AppColors.purpleTextColor),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: AppColors.skinColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: AppColors.skinColor)),
                                      errorBorder: null,
                                      focusedErrorBorder: null,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeBlock.v! * 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: List.generate(
                                                provider.brandList.length,
                                                (index) => searchChipsWidget(
                                                    provider.brandList[index].name)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                      body: Consumer<AddShoesFromAPIProvider>(
                        builder: (BuildContext context,
                            AddShoesFromAPIProvider myAddShoesFromAPIProvider,
                            Widget? child) {
                          return LoadingOverlay(
                            isLoading: myAddShoesFromAPIProvider.isLoading,
                            progressIndicator: Container(
                              color: AppColors.whiteColor,
                                child: Loader()),
                            child: SmartRefresher(
                              controller:
                                  myAddShoesFromAPIProvider.refreshController,
                              enablePullUp: (myAddShoesFromAPIProvider.currentPage == 0) ? false : true,
                              enablePullDown: false,
                              onLoading: () {
                                _addShoesFromAPIProvider
                                    .populateShoesListToDisplayBySearchQuery(
                                        searchController.text);
                              },
                              child: GridView.count(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeBlock.h! * 2),
                                scrollDirection: Axis.vertical,
                                childAspectRatio: 0.85,
                                crossAxisCount: 2,
                                crossAxisSpacing: SizeBlock.h! * 20,
                                mainAxisSpacing: SizeBlock.v! * 10,
                                shrinkWrap: true,
                                children: List.generate(
                                    myAddShoesFromAPIProvider
                                        .sneakerListToDisplay
                                        .length, (index) {
                                  APISneakerModel apiSneakerModel =
                                      myAddShoesFromAPIProvider
                                          .sneakerListToDisplay[index];
                                  return ShoesFromAPIWidget(
                                    apiSneakerModel: apiSneakerModel,
                                    onTap: () {
                                      Get.to(() => AddShoesFromAPIIndividualShoesPage(sneakerModel: apiSneakerModel,));
                                    },
                                  );
                                }),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget searchChipsWidget(String? searchData) {
    return GestureDetector(
      onTap: () {
        searchController.text = searchData ?? "";
        //clearing the
        //clearing a previous array of sneakers and page displayed index
        _addShoesFromAPIProvider.clearPageOutputs();
        //updating the list displayed
        _addShoesFromAPIProvider
            .populateShoesListToDisplayBySearchQuery(searchData ?? "");
      },
      child: Container(
        margin: EdgeInsets.only(right: SizeBlock.h! * 5),
        padding: EdgeInsets.symmetric(
            vertical: SizeBlock.v! * 8, horizontal: SizeBlock.h! * 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.skinColor,
        ),
        child: FittedBox(
          child: Text(
            searchData ?? "",
            style: AppTextStyle.openSansPurple().copyWith(
                fontSize: SizeBlock.v! * 14, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
