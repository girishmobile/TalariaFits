import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:talaria/constants/fb_collections.dart';
import 'package:talaria/models/my_closet_model.dart';
import 'package:talaria/models/rating.dart';
import 'package:talaria/models/shoes_model.dart';
import 'package:talaria/models/user_model.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/images.dart';
import 'package:talaria/utils/loader.dart';
import 'package:talaria/utils/show_message.dart';
import 'package:talaria/utils/text_style.dart';
import 'package:talaria/widgets/app_button.dart';
import '../../utils/size_block.dart';

class ProductDetailScreen extends StatefulWidget {
  final ShoesDataModel? shoes;

  const ProductDetailScreen({Key? key, this.shoes}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController imageDisplayedController = PageController();
  final PageController _controller = PageController();
  SolidController bottomController = SolidController();
  TextEditingController reviewController = TextEditingController();
  double rating = 5;

  // ColorData? colorName;
  String? shoeSize;
  int imageDisplayedIndex = 0;
  int colorIndex = 0;
  int sizeIndex = 0;
  late List<String> imagesKeys;

  late List<String> sliderImagesToDisplay = [];

  @override
  void initState() {
    imagesKeys = widget.shoes!.images!.keys.toList();
    sliderImagesToDisplay = [widget.shoes!.mainImage!];
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, _) {
      return LoadingOverlay(
        isLoading: provider.isLoading,
        progressIndicator: Loader(),
        child: Scaffold(
            backgroundColor: AppColors.purpleTextColor,
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
                            expandedHeight: SizeBlock.v! * 275,
                            floating: false,
                            //pinned: true,
                            leading: const SizedBox(),
                            backgroundColor: Colors.transparent,
                            flexibleSpace: FlexibleSpaceBar(
                              collapseMode: CollapseMode.parallax,
                              background: Stack(
                                children: [
                                  SizedBox(
                                    height: 25.h,
                                    width: Get.width,
                                    child: PageView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      controller: imageDisplayedController,
                                      children: List.generate(
                                          sliderImagesToDisplay.length,
                                          (index) => Container(
                                              width: Get.width,
                                              height: 15.h,
                                              padding: const EdgeInsets.only(
                                                  bottom: 0),
                                              decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      sliderImagesToDisplay[
                                                          imageDisplayedIndex],
                                                  fit: BoxFit.cover,
                                                ),
                                              ))),
                                    ),
                                  ),
                                  if (imageDisplayedIndex != 0)
                                    Positioned.fill(
                                      child: Align(
                                        child: GestureDetector(
                                          onTap: () {
                                            imageDisplayedController
                                                .animateToPage(
                                                    imageDisplayedIndex - 1,
                                                    duration: const Duration(
                                                        milliseconds: 1),
                                                    curve: Curves.bounceIn);
                                            imageDisplayedIndex--;
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.arrow_back_ios_rounded,
                                            color: AppColors.greyColor,
                                            size: SizeBlock.v! * 50,
                                          ),
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),
                                  if (imageDisplayedIndex !=
                                      sliderImagesToDisplay.length - 1)
                                    Positioned.fill(
                                      child: Align(
                                        child: GestureDetector(
                                          onTap: () {
                                            imageDisplayedController
                                                .animateToPage(
                                                    imageDisplayedIndex + 1,
                                                    duration: Duration(
                                                        milliseconds: 1),
                                                    curve: Curves.bounceIn);
                                            imageDisplayedIndex++;
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: AppColors.greyColor,
                                            size: SizeBlock.v! * 50,
                                          ),
                                        ),
                                        alignment: Alignment.centerRight,
                                      ),
                                    ),
                                ],
                              ),
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
                                    2, 0), // changes position of shadow
                              ),
                            ],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: ListView(
                          padding:
                              EdgeInsets.symmetric(vertical: SizeBlock.v! * 15),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.shoes?.name ?? "",
                                    style: AppTextStyle.openSansPurple()
                                        .copyWith(
                                            fontSize: SizeBlock.v! * 21,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ),
                                if (widget.shoes!.shoesRatingValue != 0)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "(${widget.shoes!.shoesRatingValue.toStringAsFixed(1)}",
                                        style: AppTextStyle.openSansSemiBold()
                                            .copyWith(
                                                fontSize: SizeBlock.v! * 16,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.blackColor),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: AppColors.goldenColor,
                                        size: SizeBlock.v! * 15,
                                      ),
                                      Text(
                                        ")",
                                        style: AppTextStyle.openSansSemiBold()
                                            .copyWith(
                                                fontSize: SizeBlock.v! * 16,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.blackColor),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: SizeBlock.v! * 10,
                            ),
                            Text(
                              widget.shoes?.description ?? "",
                              style: AppTextStyle.openSansPurple().copyWith(
                                  fontSize: SizeBlock.v! * 18,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: SizeBlock.v! * 10,
                            ),
                            Text(
                              "Size",
                              style: AppTextStyle.openSansPurple().copyWith(
                                  fontSize: SizeBlock.v! * 28,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: SizeBlock.v! * 5,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                    widget.shoes!.size?.length ?? 0,
                                    (index) => shoesSizeWidget(index)),
                              ),
                            ),
                            SizedBox(
                              height: SizeBlock.v! * 10,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(imagesKeys.length,
                                    (index) => shoesColorWidget(index)),
                              ),
                            ),
                            SizedBox(
                              height: SizeBlock.v! * 10,
                            ),
                            AppButtonWidget(
                              widget: Text(
                                provider.checkClosetAdded(
                                        shoeId: widget.shoes!.id!,
                                        selectedSize:
                                            widget.shoes!.size![sizeIndex])
                                    ? "Added to closet"
                                    : "Add to Closet",
                                style: AppTextStyle.openSansSemiBold().copyWith(
                                    fontSize: SizeBlock.v! * 18,
                                    color: provider.checkClosetAdded(
                                            shoeId: widget.shoes!.id!,
                                            selectedSize:
                                                widget.shoes!.size![sizeIndex])
                                        ? AppColors.blackColor
                                        : AppColors.purpleTextColor),
                              ),
                              isDisabled: provider.checkClosetAdded(
                                      shoeId: widget.shoes!.id!,
                                      selectedSize:
                                          widget.shoes!.size![sizeIndex])
                                  ? true
                                  : false,
                              onTap: () {
                                if (sizeIndex == -1) {
                                  ShowMessage.inSnackBar(
                                      title: "OOPS!",
                                      message: "Please select a size first",
                                      color: Colors.red);
                                } else if (colorIndex == -1) {
                                  ShowMessage.inSnackBar(
                                      title: "OOPS!",
                                      message: "Please select a color first",
                                      color: Colors.red);
                                } else {
                                  provider.addToCloset(addToCloset());
                                }
                              },
                            ),
                            Divider(
                              color: AppColors.blackColor,
                            ),
                            if (widget.shoes?.shoesRating.indexWhere(
                                    (element) =>
                                        element.userId ==
                                        provider.userData.email) ==
                                -1)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rate This Shoe",
                                    style: AppTextStyle.openSansPurple()
                                        .copyWith(
                                            fontSize: SizeBlock.v! * 28,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: SizeBlock.v! * 5,
                                  ),
                                  Center(
                                    child: RatingBar.builder(
                                      initialRating: 5,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      unratedColor: Colors.grey,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 3.w),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (val) {
                                        rating = val;
                                        log(rating.toString());
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  TextFormField(
                                    controller: reviewController,
                                    cursorColor: AppColors.purpleTextColor,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.send,
                                    onChanged: (val) {
                                      setState(() {});
                                    },
                                    style: AppTextStyle.comfortaaBold()
                                        .copyWith(
                                            fontSize: 10.sp,
                                            color: AppColors.purpleTextColor),
                                    decoration: InputDecoration(
                                      hintText: "Write a review...",
                                      fillColor: AppColors.whiteColor,
                                      filled: true,
                                      isDense: true,
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.send),
                                        color: AppColors.goldenColor,
                                        iconSize: 30,
                                        onPressed: () async {
                                          provider.startLoading();
                                          ShoeRatingModel ratingModel =
                                              ShoeRatingModel(
                                                  createdAt: Timestamp.now(),
                                                  userId:
                                                      provider.userData.email,
                                                  rating: rating,
                                                  message:
                                                      reviewController.text);
                                          widget.shoes?.shoesRating
                                              .add(ratingModel);
                                          await widget.shoes?.reference
                                              ?.collection("ratings")
                                              .doc(provider.userData.email)
                                              .set(ratingModel.toJson());
                                          provider.update();
                                          provider.stopLoading();
                                        },
                                      ),
                                      hintStyle: AppTextStyle.comfortaaBold()
                                          .copyWith(
                                              fontSize: 10.sp,
                                              color: AppColors.purpleTextColor),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: AppColors.blackColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: AppColors.blackColor)),
                                      errorBorder: null,
                                      focusedErrorBorder: null,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Divider(
                                    color: AppColors.blackColor,
                                  ),
                                ],
                              ),
                            if (widget.shoes?.shoesRating.length != 0)
                              Text(
                                "Reviews",
                                style: AppTextStyle.openSansPurple().copyWith(
                                    fontSize: SizeBlock.v! * 28,
                                    fontWeight: FontWeight.w600),
                              ),
                            SizedBox(
                              height: SizeBlock.v! * 5,
                            ),
                            ...List.generate(
                                widget.shoes?.shoesRating.length ?? 0,
                                (index) => reviewWidget(
                                    widget.shoes!.shoesRating[index]))
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

  Widget reviewWidget(ShoeRatingModel shoeRating) {
    return FutureBuilder(
        future: FBCollections.users.doc(shoeRating.userId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          UserModel? userModel;
          if (snapshot.data?.data() != null) {
            userModel = UserModel.fromJson(snapshot.data?.data());
          }
          if (userModel != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.goldenColor),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(120),
                        child: userModel.profileImage == null
                            ? Image.asset(
                                AppImages.user,
                                scale: 4,
                              )
                            : CachedNetworkImage(
                                imageUrl: userModel.profileImage ?? "",
                                fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      (userModel.firstName ?? "") +
                          " " +
                          (userModel.lastName ?? ""),
                      style: AppTextStyle.openSansSemiBold(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: shoeRating.rating ?? 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: true,
                      itemSize: 25,
                      unratedColor: Colors.grey,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (val) {
                        rating = val;
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      DateFormat("MM-dd-yyyy")
                          .format(shoeRating.createdAt!.toDate()),
                      style: AppTextStyle.openSansSemiBold()
                          .copyWith(fontSize: 10.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  shoeRating.message ?? "",
                  style:
                      AppTextStyle.openSansSemiBold().copyWith(fontSize: 10.sp),
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            );
          } else {
            return SizedBox();
          }
        });
  }

  Widget shoesColorWidget(int index) {
    String colorKeyName = imagesKeys[index];
    return GestureDetector(
      onTap: () {
        sliderImagesToDisplay = widget.shoes!.images![colorKeyName]!;
        colorIndex = index;
        imageDisplayedIndex = 0;
        setState(() {});
        imageDisplayedController.jumpToPage(index);
      },
      child: Container(
          width: 70,
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: colorIndex == index
                      ? AppColors.themeColor
                      : AppColors.goldenColor)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: widget.shoes!.images![colorKeyName]!.first,
              //widget.shoes!.color![index].colorImageUrl ?? "",
              fit: BoxFit.cover,
            ),
          )),
    );
  }

  Widget shoesSizeWidget(int index) {
    return GestureDetector(
      onTap: () {
        shoeSize = widget.shoes!.size![index].toString();
        sizeIndex = index;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(7),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.whiteColor,
            border: Border.all(
                color: sizeIndex == index
                    ? AppColors.themeColor
                    : AppColors.goldenColor)),
        child: FittedBox(
          child: Text(
            widget.shoes!.size![index].toString(),
            style: AppTextStyle.openSansPurple().copyWith(
                fontSize: 12.sp,
                color: sizeIndex == index
                    ? AppColors.themeColor
                    : AppColors.goldenColor),
          ),
        ),
      ),
    );
  }

  MyClosetModel addToCloset() {
    return MyClosetModel(
        createdAt: Timestamp.now(),
        shoesId: widget.shoes?.id,
        shoesDataModel: widget.shoes,
        selectedSize: widget.shoes!.size![sizeIndex]);
  }
}
