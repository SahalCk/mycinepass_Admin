import 'package:cinepass_admin/utils/sized_boxes.dart';
import 'package:cinepass_admin/views/widgets/admin_panel_option_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                sizedBoxHeight20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back,',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w100),
                        ),
                        Text('Sahal',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    Container(
                      height: Adaptive.h(5.6),
                      width: Adaptive.w(11.5),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          image: DecorationImage(
                              image: AssetImage('assets/admin.jpg'),
                              fit: BoxFit.fill)),
                    )
                  ],
                ),
                sizedBoxHeight40,
                const AdminPanelOptionButton(
                    optionName: 'Manage Banners',
                    image: 'assets/admin_panel/manage_banners.png',
                    navigateTo: AdminPanelScreen()),
                sizedBoxHeight25,
                const AdminPanelOptionButton(
                    optionName: 'Manage Movies',
                    image: 'assets/admin_panel/manage_movies.png',
                    navigateTo: AdminPanelScreen()),
                sizedBoxHeight25,
                const AdminPanelOptionButton(
                    optionName: 'Manage Users',
                    image: 'assets/admin_panel/manage_users.png',
                    navigateTo: AdminPanelScreen()),
                sizedBoxHeight25,
                const AdminPanelOptionButton(
                    optionName: 'Manage Owners',
                    image: 'assets/admin_panel/manage_owners.png',
                    navigateTo: AdminPanelScreen()),
                sizedBoxHeight25,
                const AdminPanelOptionButton(
                    optionName: 'View Bookings',
                    image: 'assets/admin_panel/view_bookings.png',
                    navigateTo: AdminPanelScreen()),
                sizedBoxHeight25,
                const AdminPanelOptionButton(
                    optionName: 'Manage Coupons',
                    image: 'assets/admin_panel/manage_coupons.png',
                    navigateTo: AdminPanelScreen()),
                sizedBoxHeight25,
                const AdminPanelOptionButton(
                    optionName: 'View Revenue',
                    image: 'assets/admin_panel/view_revenue.png',
                    navigateTo: AdminPanelScreen()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
