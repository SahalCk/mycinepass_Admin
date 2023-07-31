import 'package:cinepass_admin/controllers/manage_banner_controller.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/screens/banner_section/screen_add_banner.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_banner.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_floating_action_button.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManageBannersScreen extends StatelessWidget {
  const ManageBannersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appBar = CinePassAppBar();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          SystemUiOverlayStyle.light.copyWith(statusBarColor: backgroundColor),
      child: Scaffold(
        appBar:
            appBar.cinePassAppBar(context: context, title: 'Manage Banners'),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('movieBannerDetails')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done ||
                    snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final bannerController =
                        Provider.of<ManageBannerController>(context,
                            listen: false);
                    bannerController.addValueToList(snapshot);
                    return bannerController.bannerList.isNotEmpty
                        ? ListView.separated(
                            padding: EdgeInsets.only(top: Adaptive.h(1.2)),
                            itemBuilder: (context, index) {
                              return CinePassBanner(
                                movieName: bannerController
                                    .bannerList[index].movieName,
                                movieDescription: bannerController
                                    .bannerList[index].movieDescription,
                                imgUrl: bannerController
                                    .bannerList[index].bannerImageUrl,
                                index: index,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return sizedBoxHeight20;
                            },
                            itemCount: bannerController.bannerList.length)
                        : const Center(
                            child: Text(
                              'Banners are not added!',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          );
                  } else {
                    return const ScaffoldMessenger(
                        child: Text('Something went wrong'));
                  }
                } else {
                  return const Center(child: CinePassLoading());
                }
              },
            )),
        floatingActionButton: CinePassFloatingActionButton(
            function: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddNewBannerScreen()));
            },
            text: 'Add New Banner'),
      ),
    );
  }
}
