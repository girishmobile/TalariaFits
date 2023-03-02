import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talaria/models/my_closet_model.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/utils/colors.dart';
import 'package:talaria/utils/size_block.dart';
import 'package:talaria/utils/text_style.dart';

import '../../widgets/closet_widgets/closet_list_widget.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({Key? key}) : super(key: key);

  @override
  _ClosetScreenState createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, _) {
      return Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Closet",
                style: AppTextStyle.openSansSemiBold().copyWith(color: AppColors.goldenColor, fontSize: SizeBlock.v! * 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: SizeBlock.v! * 10,
              ),
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.symmetric(horizontal: SizeBlock.h! * 2),
                  scrollDirection: Axis.vertical,
                  childAspectRatio: 0.85,
                  crossAxisCount: 2,
                  crossAxisSpacing: SizeBlock.h! * 20,
                  mainAxisSpacing: SizeBlock.v! * 10,
                  shrinkWrap: true,
                  children:
                      List.generate(provider.closetList.length, (index) {
                    MyClosetModel closet = provider.closetList[index];
                    return ClosetListWidget(
                        shoes: closet.shoesDataModel, closetModel: closet);
                  }),
                ),
              ),
            ],
          ));
    });
  }
}
