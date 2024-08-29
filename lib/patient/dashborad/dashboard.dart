import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart'; // Ensure this import is correct
import 'package:app_apponitmnet/doctor/screens/doctor-notes-screen.dart';
import 'package:app_apponitmnet/doctor/screens/profile_screens/dcotor-mian-profile.dart';
import 'package:app_apponitmnet/patient/screens/appointment-show.dart';
import 'package:app_apponitmnet/patient/screens/home_screen.dart';
import 'package:app_apponitmnet/util/all_chat.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum _SelectedTab { Home, Chat, Appointment, Profile }

class PatientNavigationController extends GetxController {
  final PageController pageController = PageController();
  var selectedIndex = _SelectedTab.Home.obs;

  void changeTab(int index) {
    selectedIndex.value = _SelectedTab.values[index];
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 10), // Adjust duration as needed
      curve: Curves.ease,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final User? firebaseUser = FirebaseAuth.instance.currentUser;

class _DashboardScreenState extends State<DashboardScreen> {
  final PatientNavigationController controller =
      Get.put(PatientNavigationController());

  int _currentPage = 0;
  Color _currentColor = AppColors.textColor;
  final List<TabData> tabs = [
    TabData(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      iconData: Icons.home,
      title: "Home",
      tabColor: Colors.black,
      tabGradient: LinearGradient(
        colors: [Colors.white, Colors.red],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
    ),
    TabData(
      iconData: CupertinoIcons.chat_bubble_fill,
      title: "Chat",
      tabColor: Colors.deepPurple,
      tabGradient: LinearGradient(
        colors: [Colors.blue, Colors.red],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
    ),
    TabData(
      iconData: CupertinoIcons.book_fill,
      title: "Appointment",
      tabColor: Colors.deepPurple,
      tabGradient: LinearGradient(
        colors: [Colors.blue, Colors.red],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
    ),
    TabData(
      iconData: Icons.person,
      title: "Profile",
      tabColor: Colors.white,
      tabGradient: LinearGradient(
        colors: [Colors.white, Colors.white],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
    ),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  //   _updateUserStatus('online'); // Mark user as online when they open the app
  // }
  //
  // @override
  // void dispose() {
  //   _updateUserStatus(
  //       'offline'); // Mark user as offline when they close the app
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }
  //
  // void _updateUserStatus(String status) {
  //   if (firebaseUser != null) {
  //     _firestore
  //         .collection('Users')
  //         .doc(firebaseUser!.uid)
  //         .update({'status': status});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
          controller.changeTab(index);
        },
        children: [
          HomeScreen(),
          AllChatScreen(),
          AppointmentListScreen(),
          AllProfile(),
        ],
      ),
      bottomNavigationBar: CubertoBottomBar(
        barBackgroundColor: AppColors.primaryColor,
        key: const Key("BottomBar"),
        inactiveIconColor: Colors.white,
        textColor: AppColors.textColor,
        barShadow: [
          BoxShadow(
              color: AppColors.primaryColor,
              blurRadius: 20.0,
              blurStyle: BlurStyle.outer),
        ],
        tabStyle: CubertoTabStyle.styleNormal,
        selectedTab: _currentPage,
        tabs: tabs,
        onTabChangedListener: (position, title, color) {
          setState(() {
            _currentPage = position;
            if (color != null) {
              _currentColor = color;
            }
            controller.changeTab(position);
          });
        },
      ),
    );
  }
}
