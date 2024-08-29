import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class DateCapsule extends StatefulWidget {
  final DateTime date;
  final int dates;
  final bool isSelected;
  final VoidCallback? onTap;

  DateCapsule({
    Key? key,
    required this.date,
    required this.isSelected,
    this.onTap,
    required this.dates,
  }) : super(key: key);

  @override
  _DateCapsuleState createState() => _DateCapsuleState();
}

class _DateCapsuleState extends State<DateCapsule> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        if (widget.onTap != null) widget.onTap!();
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 110.w,
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: _isSelected ? Colors.grey : Color(0xffFF6D60),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            if (_isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4.0,
                spreadRadius: 1.0,
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              EasyDateFormatter.shortMonthName(widget.date, "en_US"),
              style: TextStyle(
                fontSize: 12.sp,
                color: _isSelected ? Color(0xff393646) : Colors.white38,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              widget.dates.toString(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: _isSelected ? Color(0xff393646) : Colors.white,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              EasyDateFormatter.shortDayName(widget.date, "en_US"),
              style: TextStyle(
                fontSize: 12.sp,
                color: _isSelected ? Color(0xff393646) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeCapsule extends StatefulWidget {
  final int time;
  final bool isSelected;
  final VoidCallback? onTap;
  final String text;

  TimeCapsule({
    Key? key,
    required this.time,
    required this.isSelected,
    this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  _TimeCapsuleState createState() => _TimeCapsuleState();
}

class _TimeCapsuleState extends State<TimeCapsule> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        if (widget.onTap != null) widget.onTap!();
      },
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 100.w,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: _isSelected ? Colors.grey : Color(0xffFF6D60),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            if (_isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4.0,
                spreadRadius: 1.0,
              ),
          ],
        ),
        child: Center(
          child: Text(
            '${widget.time} ${widget.text}',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: _isSelected ? Color(0xff393646) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
