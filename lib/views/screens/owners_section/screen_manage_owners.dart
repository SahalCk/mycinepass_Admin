import 'package:cinepass_admin/controllers/manage_owners_controller.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/screens/owners_section/screen_verify_owners.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_owner_card.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManageOwnersScreen extends StatelessWidget {
  const ManageOwnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ownerSearchController = TextEditingController();
    final ownersController =
        Provider.of<ManageOwnersController>(context, listen: false);
    ownersController.getAllOwners(context);
    final appBar = CinePassAppBar();
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: backgroundColor),
        child: Scaffold(
            appBar:
                appBar.cinePassAppBar(context: context, title: 'Manage Owners'),
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
                child: Column(children: [
                  sizedBoxHeight20,
                  CinePassSearchField(
                    controller: ownerSearchController,
                    function: (ownerSearchController) =>
                        ownersController.searchTheater(ownerSearchController),
                    clearingFunction: () {
                      ownerSearchController.clear();
                      ownersController.searchTheater('');
                    },
                    hint: 'Search Owner',
                  ),
                  sizedBoxHeight30,
                  Expanded(
                    child: Consumer<ManageOwnersController>(
                      builder: (context, value, child) {
                        return value.allOwnersList.isNotEmpty
                            ? ListView.separated(
                                padding:
                                    EdgeInsets.only(bottom: Adaptive.h(1.5)),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VerifyOwnersScreen(
                                                      ownerModel: value
                                                              .searchedOwnerList[
                                                          index])));
                                    },
                                    child: CinePassOwnerCard(
                                      ownerId:
                                          value.searchedOwnerList[index].id,
                                      theaterName:
                                          value.searchedOwnerList[index].name,
                                      phoneNumber: value
                                          .allOwnersList[index].phone
                                          .toString(),
                                      ownerMail:
                                          value.searchedOwnerList[index].email,
                                      ownerLicense: value
                                          .searchedOwnerList[index].licence,
                                      adhar: value.allOwnersList[index].adhaar
                                          .toString(),
                                      location: value
                                          .searchedOwnerList[index].location,
                                      isBlocked:
                                          value.searchedOwnerList[index].block,
                                      status:
                                          value.searchedOwnerList[index].status,
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return sizedBoxHeight10;
                                },
                                itemCount: value.searchedOwnerList.length)
                            : Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: const Color.fromARGB(
                                        255, 207, 234, 255),
                                    color: primaryColor,
                                    strokeWidth: 6),
                              );
                      },
                    ),
                  )
                ]))));
  }
}
