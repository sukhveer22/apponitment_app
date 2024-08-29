// import 'package:app_apponitmnet/models/doctor_model.dart';
// import 'package:app_apponitmnet/patient/screens/appointment_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'app_color.dart';
//
// class CustomCard extends StatelessWidget {
//   final Doctors doctor;
//   final User? firebaseuser = FirebaseAuth.instance.currentUser;
//
//   CustomCard({
//     super.key,
//     required this.doctor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 130,
//       margin: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(18)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 50.h,
//                 width: 50.w,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(12.r),
//                   ),
//                 ),
//                 child: Image(
//                     image: NetworkImage(doctor.profilePictureUrl.toString())),
//               ),
//               Row(
//                 children: [
//                   Icon(
//                     CupertinoIcons.star_lefthalf_fill,
//                     size: 20,
//                     color: Colors.green,
//                   ),
//                   Text(
//                     "55.0",
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       color: AppColors.textColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 doctor.phoneNumber.toString(),
//                 style: TextStyle(
//                   fontSize: 19.sp,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textColor,
//                 ),
//               ),
//               ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxHeight: 18,
//                   maxWidth: MediaQuery.of(context).size.width * 0.5,
//                 ),
//                 child: Text(
//                   doctor.specialty,
//                   style: TextStyle(
//                     color: AppColors.textColor,
//                   ),
//                 ),
//               ),
//
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: CupertinoButton(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => AppointmentScreen(
//                             name: doctor.name,
//                             destination: doctor.specialty,
//                             imagePath: doctor.profilePictureUrl,
//                             doctorId: '',
//                           ),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       'Appointment',
//                       style: TextStyle(color: AppColors.textColor),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ).paddingSymmetric(horizontal: 15),
//     );
//   }
// }
import 'package:app_apponitmnet/patient/screens/appointment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DoctorCard extends StatelessWidget {
  final String doctorName;
  final String doctorTap;
  final String doctor;
  final String doctorImageUrl;
  final double rating;
  final String doctorId;

  DoctorCard({
    required this.doctorName,
    required this.doctorImageUrl,
    required this.rating,
    required this.doctorTap,
    required this.doctor,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(AppointmentScreen(doctorId: doctorId));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                doctorImageUrl,
                height: 80.h,
                width: 80.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 40.w,
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
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.personal_injury_sharp,
                      ),
                      Text(
                        doctorName.toString(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(CupertinoIcons.arrow_3_trianglepath),
                      Text(
                        doctorTap.toString(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(CupertinoIcons.phone),
                      Text(
                        doctor.toString(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 25.w,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      size: 80,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
