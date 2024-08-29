import 'package:app_apponitmnet/doctor/screens/profile_screens/dcotor-mian-profile.dart';
import 'package:app_apponitmnet/patient/screens/appointment-show.dart';
import 'package:app_apponitmnet/patient/screens/home_screen.dart';
import 'package:app_apponitmnet/util/all_chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart'; // Ensure this import is correct

import '../../models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum _SelectedTab { Home, Chat, Appointment, Profile }

class PatientNavigationController extends GetxController {
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

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final ChatRoomModel chatroom = ChatRoomModel();
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final PatientNavigationController controller = Get.put(PatientNavigationController());

    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          controller.selectedIndex.value = _SelectedTab.values[index];
        },
        children: [
          HomeScreen(),
          AllChatScreen(),
          AppointmentListScreen(),
          AllProfile(),
        ],
      ),
      bottomNavigationBar: Obx(
            () => MoltenBottomNavigationBar(
          selectedIndex: _SelectedTab.values.indexOf(controller.selectedIndex.value),
          domeHeight: 25,
          onTabChange: (clickedIndex) {
            controller.changeTab(_SelectedTab.values[clickedIndex]);
          },
          tabs: [
            MoltenTab(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            MoltenTab(
              icon: Icon(Icons.notification_add),
              title: Text('Chat'),
            ),
            MoltenTab(
              icon: Icon(Icons.color_lens),
              title: Text('Appointment'),
            ),
            MoltenTab(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
