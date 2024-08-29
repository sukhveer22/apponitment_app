import 'package:app_apponitmnet/util/app_color.dart';
import 'package:app_apponitmnet/util/app_config.dart';
import 'package:app_apponitmnet/util/custom_button.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/doctor_schedule_controller.dart';

class DoctorScheduleScreen extends StatelessWidget {
  const DoctorScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DoctorScheduleController appointmentController =
        Get.put(DoctorScheduleController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Appointment', style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Select Start Date and Time'),
            _buildDateSelector(context, appointmentController,
                isStartTime: true),
            SizedBox(height: 20.h),
            _buildSectionHeader('Select End Date and Time'),
            _buildDateSelector(context, appointmentController,
                isStartTime: false),
            SizedBox(height: 40.h),
            _buildSaveButton(appointmentController, context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.black,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _buildDateSelector(
      BuildContext context, DoctorScheduleController controller,
      {required bool isStartTime}) {
    return Container(
      padding: EdgeInsets.all(15.w),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Color(0xffCAD6FF),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          Obx(() {
            return EasyDateTimeLine(
              initialDate: isStartTime
                  ? controller.startDate.value
                  : controller.endDate.value,
              onDateChange: (selectedDate) {
                if (isStartTime) {
                  controller.setStartDate(selectedDate);
                } else {
                  controller.setEndDate(selectedDate);
                }
              },
              dayProps: EasyDayProps(
                height: 56.h,
                width: 124.w,
              ),
              headerProps: const EasyHeaderProps(
                dateFormatter: DateFormatter.fullDateDMY(),
              ),
              itemBuilder: (context, date, isSelected, onTap) {
                return InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    width: 124.w,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xffFF6D60) : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          EasyDateFormatter.shortMonthName(date, "en_US"),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xff6D5D6E),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xff393646),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          EasyDateFormatter.shortDayName(date, "en_US"),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xff6D5D6E),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
          SizedBox(height: 20.h),
          Obx(() {
            return Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: Colors.white,
              ),
              child: Center(
                child: TextButton(
                  onPressed: () => isStartTime
                      ? _selectStartTime(context, controller)
                      : _selectEndTime(context, controller),
                  child: Text(
                    isStartTime
                        ? controller.selectedStartTime.value != null
                            ? 'Selected Start Time: ${controller.selectedStartTime.value!.format(context)}'
                            : 'Select Start Time'
                        : controller.selectedEndTime.value != null
                            ? 'Selected End Time: ${controller.selectedEndTime.value!.format(context)}'
                            : 'Select End Time',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSaveButton(
      DoctorScheduleController appointmentController, BuildContext context) {
    return Center(
      child: SizedBox(
        width: 0.5.sw,
        child: CustomButton(
          onPressed: () => appointmentController.saveToFirebase(context),
          text: 'Save Appointment',
          textColor: Colors.black,
          color: AppColors.primaryColor,
          isLoading: appointmentController.saveDataLoading.value,
        ),
      ),
    );
  }

  Future<void> _selectStartTime(
      BuildContext context, DoctorScheduleController controller) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    controller.setStartTime(time);
  }

  Future<void> _selectEndTime(
      BuildContext context, DoctorScheduleController controller) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    controller.setEndTime(time);
  }
}
