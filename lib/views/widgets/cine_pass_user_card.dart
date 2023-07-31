import 'package:cinepass_admin/controllers/manage_users_controller.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassUserCard extends StatelessWidget {
  final String userName;
  final String userMail;
  final String userPhone;
  final String userID;
  final bool isBlocked;
  const CinePassUserCard(
      {super.key,
      required this.userName,
      required this.userMail,
      required this.userPhone,
      required this.userID,
      required this.isBlocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Adaptive.h(1.3)),
      height: Adaptive.h(13.75),
      width: Adaptive.w(100),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(84, 168, 229, 0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(userMail, style: const TextStyle(color: Colors.white)),
                  Text(userPhone, style: const TextStyle(color: Colors.white)),
                  Text(
                    userID,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 148, 148, 148)),
                  )
                ],
              ),
              SizedBox(
                width: Adaptive.h(10),
                height: Adaptive.h(4),
                child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(child: CinePassLoading());
                        },
                      );
                      final controller = Provider.of<ManageUsersController>(
                          context,
                          listen: false);
                      isBlocked
                          ? await controller.unblockUser(context, userID)
                          : await controller.blockUser(context, userID);
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: isBlocked ? Colors.green : Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Text(
                      isBlocked ? 'Unblock' : 'Block',
                      style: const TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
