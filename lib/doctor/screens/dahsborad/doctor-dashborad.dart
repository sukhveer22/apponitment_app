import 'package:app_apponitmnet/doctor/screens/doctor_home_screen.dart';
import 'package:app_apponitmnet/doctor/screens/profile_screens/dcotor-mian-profile.dart';
import 'package:app_apponitmnet/patient/screens/appointment-show.dart';
import 'package:app_apponitmnet/util/all_chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart'; // Ensure this import is correct

import '../../../models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum _SelectedTab { Home, Chat, Appointment, Profile }

class NavigationController extends GetxController {
  final PageController pageController = PageController();
  var selectedIndex = _SelectedTab.Home.obs;

  void changeTab(_SelectedTab tab) {
    selectedIndex.value = tab;
    pageController.animateToPage(
      _SelectedTab.values.indexOf(tab),
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
}

class Doctordashborad extends StatelessWidget {
  Doctordashborad({super.key});

  final ChatRoomModel chatroom = ChatRoomModel();
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());

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
        () => DotNavigationBar(
          currentIndex:
              _SelectedTab.values.indexOf(controller.selectedIndex.value),
          onTap: (index) {
            controller.changeTab(_SelectedTab.values[index]);
          },
          items: [
            DotNavigationBarItem(
              icon: Icon(Icons.home),
              selectedColor: Colors.blue,
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.messenger),
              selectedColor: Colors.blue,
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.badge),
              selectedColor: Colors.blue,
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.manage_accounts_sharp),
              selectedColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
