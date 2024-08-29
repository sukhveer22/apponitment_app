import 'package:app_apponitmnet/patient/controllers/pt_home_screen_controller.dart';
import 'package:app_apponitmnet/role_method/select_role_controller.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:app_apponitmnet/util/custom_text_field.dart';
import 'package:app_apponitmnet/util/doctor_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../util/app_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

  final User? currentUser = FirebaseAuth.instance.currentUser;
  final SelectRoleController userrole = Get.put(SelectRoleController());

  @override
  void initState() {
    controller.fetchActiveDoctors();
    controller.updateSearchText("");
    userrole.setActiveStatus(true);
    super.initState();
  }

  @override
  void dispose() {
    userrole.setActiveStatus(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchActiveDoctors();

    return Obx(
      () => Scaffold(
        drawerScrimColor: Colors.white,
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 220,
                  child: Column(
                    children: [
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(18.r),
                            bottomLeft: Radius.circular(18.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hi ${currentUser?.displayName.toString() ?? "Please Enter Name"} !",
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Find Your Doctor",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    // Optional: Shadow around the image
                                    offset: Offset(0, 2),
                                    // Shadow position
                                    blurRadius: 4, // Shadow blur
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  currentUser?.photoURL?.toString() ??
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQanlasPgQjfGGU6anray6qKVVH-ZlTqmuTHw&s",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.error,
                                    ); // Shows an error icon if the image fails to load
                                  },
                                ),
                              ),
                            )
                          ],
                        ).paddingOnly(top: 20.h).paddingAll(15.w),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 32,
                  left: 0, // Adjust positioning as needed
                  right: 0, // Adjust positioning as needed
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: AppConfig.screenWidth * 0.9,
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                focusedBorderColor: Colors.white,
                                borderColor: Colors.white,
                                prefixIcon: const Icon(CupertinoIcons.search),
                                controller: controller.searchText,
                                hintText: "Search Doctor ...",
                                onChanged: (value) {
                                  controller.updateSearchText(value);
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(CupertinoIcons.delete),
                              onPressed: () {
                                controller.searchText.clear();
                                controller.updateSearchText('');
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (controller.searchText.text == "")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Active Doctors",
                    style: AppTextStyles.header,
                  ),
                  SizedBox(height: 20),
                  Obx(() => SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.activeDoctors.length,
                          itemBuilder: (context, index) {
                            return ActiveImageContainer(
                              imageUrl: controller.activeDoctors[index],
                            );
                          },
                        ),
                      )),
                  SizedBox(height: 20),
                  Obx(
                    () => SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.imageList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => Get.to(controller.screens[index]),
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.deepPurpleAccent.shade400,
                                    Colors.deepPurpleAccent.shade100,
                                  ]),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Image(
                                      image: AssetImage(
                                          controller.imageList[index])),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.activeDoctors.length,
                      itemBuilder: (context, index) => DoctorCard(
                        doctor: controller.numberDoctors[index],
                        doctorTap: controller.tapDoctors[index],
                        doctorName: controller.nameDoctors[index],
                        doctorImageUrl: controller.activeDoctors[index],
                        rating: 5.0,
                        doctorId: controller.idDoctors[index],
                      ),
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 10)
            else if (controller.sactiveDoctors.isNotEmpty)
              for (int index = 0;
                  index < controller.sactiveDoctors.length;
                  index++)
                ListView.builder(
                  shrinkWrap: false,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.sactiveDoctors.length,
                  itemBuilder: (context, index) => DoctorCard(
                    doctor: controller.snumberDoctors[index],
                    doctorTap: controller.stapDoctors[index],
                    doctorName: controller.snameDoctors[index],
                    doctorImageUrl: controller.sactiveDoctors[index],
                    rating: 5.0,
                    doctorId: controller.sIdDoctors[index],
                  ),
                )
            else
              Center(child: Text("No doctors available.")),
          ],
        )),
      ),
    );
  }
}

class ActiveImageContainer extends StatelessWidget {
  final String imageUrl;

  ActiveImageContainer({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 130.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.error,
                color: Colors.red,
                size: 40.w,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          },
        ),
      ),
    ).paddingSymmetric(horizontal: 10.w);
  }
}
