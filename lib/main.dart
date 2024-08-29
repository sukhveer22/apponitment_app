import 'package:app_apponitmnet/patient/screens/appointment-show.dart';
import 'package:app_apponitmnet/patient/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:app_apponitmnet/role_method/select_role_controller.dart';
import 'package:app_apponitmnet/role_method/select_role_screen.dart';
import 'package:app_apponitmnet/util/app_config.dart';
import 'package:app_apponitmnet/firebase_options.dart';
import 'package:app_apponitmnet/patient/dashborad/dashboard.dart';
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final SelectRoleController userrole =
      Get.put(SelectRoleController(), permanent: true);
  late DatabaseReference _userStatusDatabaseRef;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _realtimeDatabase = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeUserStatus();
  }

  void _initializeUserStatus() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Reference for the user's status in Firestore
      final userStatusFirestoreRef =
          _firestore.collection('Users').doc(user.uid);

      // Reference for the user's status in Realtime Database
      _userStatusDatabaseRef = _realtimeDatabase.ref('status/${user.uid}');

      // Set up a presence system using Realtime Database for reliable status updates
      _setRealtimeDatabasePresence();

      // Set initial status to online in Firestore
      _setUserStatusFirestore(userStatusFirestoreRef, 'online');

      // Listen to Realtime Database to update Firestore accordingly
      _userStatusDatabaseRef.onValue.listen((event) {
        final status = event.snapshot.value as String?;
        if (status != null) {
          _setUserStatusFirestore(userStatusFirestoreRef, status);
        }
      });
    }
  }

  void _setRealtimeDatabasePresence() {
    // User's status in Realtime Database, updated automatically
    _userStatusDatabaseRef.onDisconnect().set('offline').then((_) {
      _userStatusDatabaseRef.set('online');
    }).catchError((e) {
      print('Error setting onDisconnect: $e');
    });
  }

  void _setUserStatusFirestore(DocumentReference userRef, String status) {
    userRef.update({'status': status}).catchError((e) {
      print('Error updating Firestore status: $e');
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _userStatusDatabaseRef.set('online');
    } else {
      _userStatusDatabaseRef.set('offline');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
          // home: AllChatScreen(),
          // home:AppointmentListScreen(),
          home: _getInitialScreen(userrole),
        );
      },
    );
  }

  Widget _getInitialScreen(SelectRoleController userrole) {
    String? user = _auth.currentUser?.uid;

    if (user != null) {
      return StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('Users').doc(user).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return SelectRoleScreen();
          } else {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String role = userData['role'] ?? 'patient';
            userrole.setActiveStatus(true);
            if (role == 'Doctor') {
              return DoctorDashboard();
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

