import 'package:cinepass_admin/controllers/manage_users_controller.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_search_field.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController =
        Provider.of<ManageUsersController>(context, listen: false);
    final searchUserController = TextEditingController();
    Provider.of<ManageUsersController>(context, listen: false).getAllUsers();
    final appBar = CinePassAppBar();
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: backgroundColor),
        child: Scaffold(
            appBar:
                appBar.cinePassAppBar(context: context, title: 'Manage Users'),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
              child: Column(
                children: [
                  sizedBoxHeight20,
                  CinePassSearchField(
                    controller: searchUserController,
                    function: (searchUserController) =>
                        userController.searchUser(searchUserController),
                    clearingFunction: () {
                      searchUserController.clear();
                      userController.searchUser('');
                    },
                    hint: 'Search User',
                  ),
                  sizedBoxHeight30,
                  Expanded(
                    child: Consumer<ManageUsersController>(
                      builder: (context, value, child) {
                        return value.users.isNotEmpty
                            ? ListView.separated(
                                padding:
                                    EdgeInsets.only(bottom: Adaptive.h(1.5)),
                                itemBuilder: (context, index) {
                                  return CinePassUserCard(
                                    userName:
                                        value.searchedUsersList[index].signName,
                                    userMail: value
                                        .searchedUsersList[index].signEmail,
                                    userPhone: value
                                        .searchedUsersList[index].signPhone
                                        .toString(),
                                    userID: value.searchedUsersList[index].id,
                                    isBlocked:
                                        value.searchedUsersList[index].block,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return sizedBoxHeight10;
                                },
                                itemCount: value.searchedUsersList.length,
                              )
                            : const Center(
                                child: Text(
                                  'User not found!',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              );
                      },
                    ),
                  )
                ],
              ),
            )));
  }
}
