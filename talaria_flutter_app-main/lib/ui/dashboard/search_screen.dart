import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/models/shoes_model.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/ui/dashboard/product_detail_screen.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/widgets/search_widgets/search_list_widget.dart';
import '../../provider/search_provider.dart';
import '../../utils/size_block.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String searchString = "";
  late SearchProvider _searchProvider;
  late DashboardProvider _dashboardProvider;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _searchProvider = Provider.of<SearchProvider>(context, listen: false);
      _dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      _searchProvider.fillOriginalShoesList(_dashboardProvider.shoeList);
      _searchProvider.initializeSearchList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, _) {
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
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
                                onChanged: (val) {
                                  _searchProvider.updateSearchList(val);
                                },
                                style: AppTextStyle.openSansPurple().copyWith(
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
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: AppColors.skinColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
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
                                                  provider
                                                      .brandList[index].name)),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: Consumer<SearchProvider>(
                    builder: (BuildContext context,
                        SearchProvider mySearchProvider, Widget? child) {
                      return GridView.count(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        childAspectRatio: 0.85,
                        crossAxisCount: 2,
                        crossAxisSpacing: SizeBlock.h! * 20,
                        mainAxisSpacing: SizeBlock.v! * 10,
                        shrinkWrap: true,
                        children: List.generate(
                            mySearchProvider.searchListToDisplay.length,
                            (index) {
                          ShoesDataModel shoes =
                              mySearchProvider.searchListToDisplay[index];
                          return SearchListWidget(
                            shoes: shoes,
                            onTap: () {
                              Get.to(() => ProductDetailScreen(
                                    shoes: shoes,
                                  ));
                            },
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget searchChipsWidget(String? searchData) {
    return GestureDetector(
      onTap: () {
        searchController.text = searchData ?? "";
        _searchProvider.updateSearchList(searchData ?? "");
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
