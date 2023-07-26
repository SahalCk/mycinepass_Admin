import 'package:cinepass_admin/controllers/manage_owners_controller.dart';
import 'package:cinepass_admin/models/owner_model.dart';
import 'package:cinepass_admin/utils/colors.dart';
import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_appbar.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VerifyOwnersScreen extends StatelessWidget {
  final OwnerModel ownerModel;
  const VerifyOwnersScreen({super.key, required this.ownerModel});

  @override
  Widget build(BuildContext context) {
    String dropDownValue = ownerModel.status;
    var items = ['Approved', 'Pending', 'Denied'];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          SystemUiOverlayStyle.light.copyWith(statusBarColor: backgroundColor),
      child: Scaffold(
        appBar: CinePassAppBar()
            .cinePassAppBar(context: context, title: ownerModel.name),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Adaptive.w(5), vertical: Adaptive.h(1)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBoxHeight20,
                const Text('Theater Name',
                    style: TextStyle(
                        color: Color.fromARGB(255, 148, 148, 148),
                        fontSize: 16)),
                Text(ownerModel.name,
                    style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                sizedBoxHeight30,
                const Text('Theater ID',
                    style: TextStyle(
                        color: Color.fromARGB(255, 148, 148, 148),
                        fontSize: 16)),
                Text(ownerModel.id,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                sizedBoxHeight30,
                const Text('Theater Owner Mail',
                    style: TextStyle(
                        color: Color.fromARGB(255, 148, 148, 148),
                        fontSize: 16)),
                Text(ownerModel.email,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                sizedBoxHeight30,
                const Text('Theater Owner Phone',
                    style: TextStyle(
                        color: Color.fromARGB(255, 148, 148, 148),
                        fontSize: 16)),
                Text(ownerModel.phone.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                sizedBoxHeight30,
                const Text('Theater Owner Adhar Number',
                    style: TextStyle(
                        color: Color.fromARGB(255, 148, 148, 148),
                        fontSize: 16)),
                Text(ownerModel.adhaar.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                sizedBoxHeight30,
                const Text('Theater License Number',
                    style: TextStyle(
                        color: Color.fromARGB(255, 148, 148, 148),
                        fontSize: 16)),
                Text(ownerModel.licence.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                sizedBoxHeight30,
                const Text('Theater Owner Wallet',
                    style: TextStyle(
                        color: Color.fromARGB(255, 148, 148, 148),
                        fontSize: 16)),
                Text('₹${ownerModel.wallet.toString()}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                sizedBoxHeight30,
                const Text('Theater location',
                    style: TextStyle(
                        color: Color.fromARGB(255, 148, 148, 148),
                        fontSize: 16)),
                Text(ownerModel.location,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                sizedBoxHeight30,
                const Text('Theater License Picture',
                    style: TextStyle(
                        color: Color.fromARGB(255, 148, 148, 148),
                        fontSize: 16)),
                SizedBox(
                  height: Adaptive.h(30),
                  width: Adaptive.w(80),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:
                          Image.network(ownerModel.images, fit: BoxFit.fill)),
                ),
                sizedBoxHeight30,
                const Text('Theater is Blocked',
                    style: TextStyle(
                        color: Color.fromARGB(255, 148, 148, 148),
                        fontSize: 16)),
                Text(ownerModel.block == true ? 'Yes' : 'No',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                sizedBoxHeight30,
                const Text('Theater Verification Status',
                    style: TextStyle(
                        color: Color.fromARGB(255, 148, 148, 148),
                        fontSize: 16)),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Adaptive.w(2), vertical: Adaptive.h(0)),
                  decoration: BoxDecoration(
                      color: findBackgroundColor(ownerModel.status),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  child: DropdownButton(
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      borderRadius: BorderRadius.circular(12),
                      value: dropDownValue,
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                      ),
                      onChanged: (item) async {
                        final controller = Provider.of<ManageOwnersController>(
                            context,
                            listen: false);
                        if (item == 'Approved') {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return const CinePassLoading();
                            },
                          );
                          await controller.approveOwner(context, ownerModel.id);
                        } else if (item == 'Denied') {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return const CinePassLoading();
                            },
                          );
                          await controller.denieOwner(context, ownerModel.id);
                        }
                      }),
                ),
                sizedBoxHeight30
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color findBackgroundColor(String status) {
    if (status == 'Pending') {
      return Colors.yellow;
    } else if (status == 'Approved') {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}
