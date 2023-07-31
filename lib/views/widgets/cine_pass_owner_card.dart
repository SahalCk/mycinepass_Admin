import 'package:cinepass_admin/controllers/manage_owners_controller.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassOwnerCard extends StatelessWidget {
  final String ownerId;
  final String theaterName;
  final String phoneNumber;
  final String ownerMail;
  final String ownerLicense;
  final String adhar;
  final String location;
  final bool isBlocked;
  final String status;
  const CinePassOwnerCard(
      {super.key,
      required this.theaterName,
      required this.phoneNumber,
      required this.ownerMail,
      required this.ownerLicense,
      required this.adhar,
      required this.location,
      required this.isBlocked,
      required this.ownerId,
      required this.status});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Adaptive.h(1.3)),
      height: Adaptive.h(19.375),
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
                  SizedBox(
                    width: Adaptive.w(64),
                    child: Text(
                      theaterName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(ownerMail,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 175, 175, 175))),
                  Text(phoneNumber,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 175, 175, 175))),
                  Text(adhar,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 175, 175, 175))),
                  Text(ownerLicense,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 175, 175, 175))),
                ],
              ),
              Column(
                children: [
                  getStatus(status),
                  sizedBoxHeight60,
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
                          final controller =
                              Provider.of<ManageOwnersController>(context,
                                  listen: false);
                          isBlocked
                              ? await controller.unblockOwner(context, ownerId)
                              : await controller.blockOwner(context, ownerId);
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            backgroundColor:
                                isBlocked ? Colors.green : Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: Text(
                          isBlocked ? 'Unblock' : 'Block',
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.place,
                color: Colors.blue,
              ),
              SizedBox(
                width: Adaptive.w(80),
                child: Text(
                  location,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.blue),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget getStatus(String status) {
    if (status == 'Approved') {
      return const Row(
        children: [
          Icon(Icons.radio_button_on_sharp, color: Colors.green, size: 12),
          Text(
            'Approved',
            style: TextStyle(color: Colors.green),
          )
        ],
      );
    } else if (status == 'Denied') {
      return const Row(
        children: [
          Icon(Icons.radio_button_on_sharp, color: Colors.red, size: 12),
          Text(
            'Denied',
            style: TextStyle(color: Colors.red),
          )
        ],
      );
    } else {
      return const Row(
        children: [
          Icon(Icons.radio_button_on_sharp, color: Colors.yellow, size: 12),
          Text(
            'Pending',
            style: TextStyle(color: Colors.yellow),
          )
        ],
      );
    }
  }
}
