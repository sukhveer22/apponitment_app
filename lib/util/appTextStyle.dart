import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static final TextStyle largeTitle = TextStyle(
      fontSize: 22.sp,
      color: Colors.black,
      // fontWeight: FontWeight.w900,
      fontWeight: FontWeight.w900);

  static final TextStyle title = TextStyle(
    fontSize: 18.sp,
    color: Colors.white,
    fontWeight: FontWeight.w900,
  );

  static final TextStyle header = TextStyle(
    fontSize: 16.sp,
    color: Colors.black,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle subHeader = TextStyle(
    fontSize: 15.sp,
    color: Colors.white,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle smallHeader = TextStyle(
    fontSize: 14.sp,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle body = TextStyle(
    fontSize: 14.sp,
    color: Colors.grey[800],
  );

  static final TextStyle highlightedBody = TextStyle(
    fontSize: 14.sp,
    color: Colors.black87,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle hint = TextStyle(
    fontSize: 16.sp,
    color: Colors.black45,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle caption = TextStyle(
    fontSize: 12.sp,
    color: Colors.grey[500],
  );

  static final TextStyle errorText = TextStyle(
    fontSize: 14.sp,
    color: Colors.redAccent,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle button = TextStyle(
    fontSize: 16.sp,
    color: Colors.white,
    fontWeight: FontWeight.w700,
  );
}
