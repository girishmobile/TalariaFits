import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:talaria/provider/add_outfits_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/loader.dart';
import '../../../utils/size_block.dart';
import '../../../utils/text_style.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/navigation_wrapper_widgets/custom_app_bar.dart';

class AddOutfitsPage extends StatefulWidget {
  String shoesID;
  Map<String, String> outfitsImagesURLs;

  AddOutfitsPage({Key? key, required this.shoesID, required this.outfitsImagesURLs}) : super(key: key);

  @override
  State<AddOutfitsPage> createState() => _AddOutfitsPageState();
}

class _AddOutfitsPageState extends State<AddOutfitsPage> {

  final AddOutfitsProvider _addOutfitsProvider =
      Provider.of<AddOutfitsProvider>(Get.context!, listen: false);

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {
      _addOutfitsProvider.initializeVariables(shoesID: widget.shoesID, outfitsImagesURLs: widget.outfitsImagesURLs);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Future.delayed(Duration(seconds: 0), () {
      _addOutfitsProvider.disposeVariables();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddOutfitsProvider>(
      builder: (BuildContext context, AddOutfitsProvider myAddOutfitsProvider,
          Widget? child) {
        return LoadingOverlay(
          isLoading: myAddOutfitsProvider.isLoading,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add Outfits",
                            style: AppTextStyle.openSansSemiBold().copyWith(
                                color: AppColors.goldenColor,
                                fontSize: SizeBlock.v! * 22,
                                fontWeight: FontWeight.w600),
                          ),
                          (myAddOutfitsProvider.selectedImages.isEmpty) ? GestureDetector(
                            onTap: () async {
                              await myAddOutfitsProvider.getImagesFromGallery();
                            },
                              child: Icon(Icons.add_circle_outline, size: SizeBlock.v! * 40, color: AppColors.purpleTextColor,)) :
                          GestureDetector(
                              onTap: () async {
                                 myAddOutfitsProvider.removeSelectedImages();
                              },
                              child: Icon(Icons.delete, size: SizeBlock.v! * 40, color: AppColors.purpleTextColor,))
                        ],
                      ),
                      SizedBox(
                        height: SizeBlock.v! * 10,
                      ),
                      Expanded(
                        child: Consumer<AddOutfitsProvider>(
                          builder: (BuildContext context,
                              AddOutfitsProvider myAddOutfitsProvider,
                              Widget? child) {
                            return GridView.count(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              childAspectRatio: 0.85,
                              crossAxisCount: 2,
                              crossAxisSpacing: SizeBlock.h! * 20,
                              mainAxisSpacing: SizeBlock.v! * 10,
                              children: List.generate(
                                  myAddOutfitsProvider.outfitsImages.length,
                                  (index) {
                                    String outfitID = myAddOutfitsProvider.outfitsImages.keys.elementAt(index);
                                return (myAddOutfitsProvider.outfitsImages[outfitID]!.contains("https://")) ? GestureDetector(
                                  onTap: () {
                                    myAddOutfitsProvider.selectImage(outfitID);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: SizeBlock.h! * 5, color: (myAddOutfitsProvider.selectedImages.contains(outfitID) ? AppColors.themeColor : Colors.transparent))
                                    ),
                                    height: 100 * SizeBlock.v!,
                                    child: CachedNetworkImage(
                                      imageUrl: myAddOutfitsProvider.outfitsImages[outfitID]!,
                                      fit: BoxFit.cover,
                                    )
                                  ),
                                ) : GestureDetector(
                                  onTap: () {
                                    myAddOutfitsProvider.selectImage(outfitID);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: SizeBlock.h! * 5, color: (myAddOutfitsProvider.selectedImages.contains(outfitID) ? AppColors.themeColor : Colors.transparent))
                                    ),
                                    height: 100 * SizeBlock.v!,
                                    child: Image.file(
                                      File(myAddOutfitsProvider.outfitsImages[outfitID]!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10 * SizeBlock.v!,),
                      Center(
                        child: Container(
                          width: double.infinity,
                          child: AppButtonWidget(
                            widget: Text("Update Outfits",
                                style: AppTextStyle.openSansPurple()
                                    .copyWith(fontSize: SizeBlock.v! * 18)),
                            onTap: () async {
                              myAddOutfitsProvider.onUploadClicked();
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10 * SizeBlock.v!,)
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }
}
