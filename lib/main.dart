import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/patient/dashborad/dashboard.dart';
import 'package:app_apponitmnet/patient/screens/doctor-tap-screen/doctorheart-screen.dart';
import 'package:app_apponitmnet/patient/screens/home_screen.dart';
import 'package:app_apponitmnet/patient/screens/sacddf.dart';
import 'package:app_apponitmnet/role_method/select_role_controller.dart';
import 'package:app_apponitmnet/role_method/select_role_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:app_apponitmnet/firebase_options.dart';
import 'package:app_apponitmnet/util/app_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'doctor/screens/dahsborad/doctor-dashborad.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SelectRoleController userrole = Get.put(SelectRoleController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (context, child) {
        AppConfig.init(context);

        return GetMaterialApp(
          theme: ThemeData(
            focusColor: Colors.white,
          ),
          home: _getInitialScreen(userrole),
          // home: MyHomePage(title: "hal"),
        );
      },
    );
  }

  Widget _getInitialScreen(SelectRoleController userrole) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return SelectRoleScreen();
          } else {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String role = userData['role'];
            userrole.setActiveStatus(true);
            if (role.toString() == 'Doctor') {
              return Doctordashborad();
            } else {
              return DashboardScreen();
            }
          }
        },
      );
    } else {
      return SelectRoleScreen();
    }
  }
}


