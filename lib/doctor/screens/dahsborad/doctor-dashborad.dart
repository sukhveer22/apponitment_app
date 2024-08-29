import 'package:app_apponitmnet/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart'; // Updated import
import 'package:app_apponitmnet/doctor/screens/doctor_home_screen.dart';
import 'package:app_apponitmnet/doctor/screens/profile_screens/dcotor-mian-profile.dart';
import 'package:app_apponitmnet/patient/screens/appointment-show.dart';
import 'package:app_apponitmnet/util/all_chat.dart';

enum _SelectedTab { Home, Chat, Appointment, Profile }

class NavigationController extends GetxController {
  final PageController pageController = PageController();
  var selectedIndex = _SelectedTab.Home.obs;

  void changeTab(int index) {
    selectedIndex.value = _SelectedTab.values[index];
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 50),
      curve: Curves.ease,
    );
  }
}

class DoctorDashboard extends StatelessWidget {
  DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());

    final List<TabData> tabs = [
      TabData(
        iconData: Icons.home,
        title: "Home",
        tabColor: Colors.black,
        tabGradient: LinearGradient(
          colors: [Colors.white, Colors.blue],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      TabData(
        iconData: Icons.messenger,
        title: "Chat",
        tabColor: Colors.deepPurple,
        tabGradient: LinearGradient(
          colors: [Colors.blue, Colors.red],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      TabData(
        iconData: Icons.badge,
        title: "Appointment",
        tabColor: Colors.deepPurple,
        tabGradient: LinearGradient(
          colors: [Colors.blue, Colors.red],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      TabData(
        iconData: Icons.manage_accounts_sharp,
        title: "Profile",
        tabColor: Colors.white,
        tabGradient: LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
    ];

    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          controller.selectedIndex.value = _SelectedTab.values[index];
        },
        children: [
          DoctorHomeScreen(),
          AllChatScreen(),
          AppointmentListScreen(),
          AllProfile(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => CubertoBottomBar(
          inactiveIconColor: Colors.white,
          textColor: AppColors.textColor,
          barBackgroundColor: AppColors.primaryColor,
          // Set background color
          key: const Key("BottomBar"),
          barShadow: [
            BoxShadow(
              color: AppColors.primaryColor,
              blurRadius: 20.0,
            ),
          ],
          tabStyle: CubertoTabStyle.styleNormal,
          selectedTab:
              _SelectedTab.values.indexOf(controller.selectedIndex.value),
          tabs: tabs,
          onTabChangedListener: (position, title, color) {
            controller.changeTab(position);
          },
        ),
      ),
    );
  }
}
