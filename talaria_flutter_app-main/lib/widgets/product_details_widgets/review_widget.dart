import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/models/rating.dart';
import 'package:talaria/provider/product_detail_provider.dart';
import '../../constants/fb_collections.dart';
import '../../models/user_model.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/text_style.dart';

class ReviewWidget extends StatelessWidget {
  ShoeRatingModel shoeRatingModel;

  ReviewWidget({required this.shoeRatingModel});

  ProductDetailProvider? _productDetailProvider;

  @override
  Widget build(BuildContext context) {
    _productDetailProvider = Provider.of<ProductDetailProvider>(context, listen: false);
    return FutureBuilder(
        future: FBCollections.users.doc(shoeRatingModel.userId).get(),
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
                      initialRating: shoeRatingModel.rating ?? 0,
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
                        _productDetailProvider!.updateRating(val);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      DateFormat("MM,dd,yyyy")
                          .format(shoeRatingModel.createdAt!.toDate()),
                      style: AppTextStyle.openSansSemiBold()
                          .copyWith(fontSize: 10.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  shoeRatingModel.message ?? "",
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

}


