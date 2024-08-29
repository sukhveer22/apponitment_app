import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// SizedBox
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizedBoxExtension on Widget {
  Widget width(double width) {
    return SizedBox(width: width.w, child: this);
  }

  Widget height(double height) {
    return SizedBox(height: height.h, child: this);
  }

  Widget square(double size) {
    return SizedBox(width: size.w, height: size.h, child: this);
  }
}


///  PaddingExtension

extension PaddingExtension on Widget {
  Widget withPadding(
      {double? left, double? top, double? right, double? bottom}) {
    return Padding(
      padding: EdgeInsets.only(
        left: (left ?? 0.0).w,
        top: (top ?? 0.0).h,
        right: (right ?? 0.0).w,
        bottom: (bottom ?? 0.0).h,
      ),
      child: this,
    );
  }

  Widget withUniformPadding(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding.w),
      child: this,
    );
  }

  Widget withSymmetricPadding({double? vertical, double? horizontal}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: (vertical ?? 0.0).h,
        horizontal: (horizontal ?? 0.0).w,
      ),
      child: this,
    );
  }
}
