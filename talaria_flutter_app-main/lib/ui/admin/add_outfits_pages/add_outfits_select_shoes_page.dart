import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/models/shoes_model.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/widgets/search_widgets/search_list_widget.dart';
import '../../../provider/search_provider.dart';
import '../../../utils/size_block.dart';
import '../../../widgets/navigation_wrapper_widgets/custom_app_bar.dart';
import 'add_outfits_select_images_page.dart';


class AdminAddOutfitsSelectShoesScreen extends StatefulWidget {
  const AdminAddOutfitsSelectShoesScreen({Key? key}) : super(key: key);

  @override
  _AdminAddOutfitsSelectShoesScreenState createState() => _AdminAddOutfitsSelectShoesScreenState();
}

class _AdminAddOutfitsSelectShoesScreenState extends State<AdminAddOutfitsSelectShoesScreen> {
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
                SizedBox(height: SizeBlock.v! * 25,),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(SizeBlock.v! * 15), color: AppColors.goldenColor.withOpacity(0.5),),
                  padding: EdgeInsets.all(SizeBlock.v! * 10),
                    child: Text("Select a pair of shoes you want to add an outfit to", style: TextStyle(color: AppColors.purpleTextColor, fontSize: SizeBlock.v! * 25), textAlign: TextAlign.center,)),
                SizedBox(height: SizeBlock.v! * 10,),
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
                                                    provider.brandList[index]
                                                        .name)),
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
                      body: Consumer<SearchProvider>(
                        builder: (BuildContext context,
                            SearchProvider mySearchProvider, Widget? child) {
                          return GridView.count(
                            padding: EdgeInsets.only(bottom: SizeBlock.v! * 25),
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
                                  print(shoes.outfitsImages);
                                  return SearchListWidget(
                                    shoes: shoes,
                                    onTap: () {
                                      Get.to(() => AddOutfitsPage(
                                        shoesID: shoes.id!,
                                        outfitsImagesURLs: shoes.outfitsImages!,
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
        }),
      ),
    );
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
