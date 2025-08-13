import 'package:doors/modules/security_worker/home/infra/models/job_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/utils.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../../../widgets/custom_animated_button.dart';
import '../controllers/provider/supervisor_home_provider.dart';

class JobPostView extends StatefulWidget {
  const JobPostView({super.key});

  @override
  State<JobPostView> createState() => _JobPostViewState();
}

class _JobPostViewState extends State<JobPostView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.whiteColor),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: CustomText("Post Job", textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Consumer<SupervisorHomeProvider>(
                builder: (context, supervisorHomeProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "Fill Job Details",
                        textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12.h),

                      _buildTextField(
                        controller: supervisorHomeProvider.jobTitleController,
                        hint: "Job Title",
                        icon: Icons.work_outline,
                      ),
                      _buildTextField(
                        controller: supervisorHomeProvider.companyNameController,
                        hint: "Organization/Company",
                        icon: Icons.location_city,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 15.h),
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.whiteColor
                        ),
                        child: DropdownButtonHideUnderline(child: DropdownButton(
                                borderRadius: BorderRadius.circular(10.r),
                                isExpanded: true,
                                hint: CustomText(supervisorHomeProvider.selectedSector ?? "Select Sector"),
                                menuMaxHeight: 400,
                                menuWidth: 300,
                                items: supervisorHomeProvider.jobSectors.map((singleSector){
                                  return DropdownMenuItem(
                                      value: singleSector,
                                      child: CustomText(singleSector)
                                  );
                                }).toList(),
                                onChanged: (value){
                                  supervisorHomeProvider.selectedSector = value;
                                  supervisorHomeProvider.update();
                                }
                            )),
                      ),
                      _buildDatePicker(supervisorHomeProvider),
                      _buildTimePicker(
                          hint: "Open Time",
                          onTap: ()async{
                          final picked = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                                );

                              supervisorHomeProvider.openTime = picked;
                              supervisorHomeProvider.update();
                          },
                          selectedTime: supervisorHomeProvider.openTime,
                      ),
                      _buildTimePicker(
                          hint: "Close Time",
                          onTap: ()async{
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            supervisorHomeProvider.closeTime = picked;
                            supervisorHomeProvider.update();
                          },
                          selectedTime: supervisorHomeProvider.closeTime,
                      ),
                      _buildTextField(
                        controller: supervisorHomeProvider.salaryController,
                        hint: "Pay Amount / Salary",
                        keyboardType: TextInputType.number,
                        icon: Icons.currency_rupee,
                      ),
                      _buildTextField(
                        controller: supervisorHomeProvider.locationController,
                        hint: "Location (City, State)",
                        icon: Icons.location_on_outlined,
                      ),
                      _buildTextField(
                        controller: supervisorHomeProvider.jobDescController,
                        hint: "Job Description",

                        maxLines: 5
                      ),

                      SizedBox(height: 24.h),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:   Consumer<SupervisorHomeProvider>(
        builder: (context,supervisorHomeProvider,child) {
          return SizedBox(
            height: 60,
            child: CustomAnimatedButton(
              isLoading: supervisorHomeProvider.isLoading,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              backgroundColor: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(12.r),
              text: "Post Job",
              onPressed: () async{
                  if (_formKey.currentState!.validate() &&
                  supervisorHomeProvider.selectedDate != null &&
                  supervisorHomeProvider.openTime != null &&
                  supervisorHomeProvider.closeTime !=null
                  ) {
                    final JobModel jobData = JobModel(
                      jobTitle: supervisorHomeProvider.jobTitleController.text.trim(),
                      companyName: supervisorHomeProvider.companyNameController.text.trim(),
                      sector: supervisorHomeProvider.selectedSector,
                      address: supervisorHomeProvider.locationController.text.trim(),
                      salary: supervisorHomeProvider.salaryController.text.trim(),
                      description: supervisorHomeProvider.jobDescController.text.trim(),
                      deadline: DateFormat('dd MMM yyyy').format(supervisorHomeProvider.selectedDate!),
                      openingTime: supervisorHomeProvider.openTime!.format(context),
                      closingTime: supervisorHomeProvider.closeTime!.format(context),
                      createdAt: DateTime.now().toString(),
                    );
                    await supervisorHomeProvider.postJob(jobModel: jobData);
                  }else{
                  Utils.showToast(msg: "Please fill all fields");
                  }
              },
                     ),
          ).paddingOnly(left: 20,right: 20,bottom: 20);
        }
      ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int? maxLines,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: AppColors.primaryColor) : null,
          hintText: hint,
          filled: true,
          fillColor: AppColors.whiteColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildDatePicker(SupervisorHomeProvider supervisorHomeProvider) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () => supervisorHomeProvider.pickDate(context: context),
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.whiteColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: AppColors.primaryColor),
              SizedBox(width: 10.w,),
              CustomText(
                supervisorHomeProvider.selectedDate == null
                    ? "Last date"
                    : DateFormat('dd MMM yyyy').format(supervisorHomeProvider.selectedDate!),
                textStyle: TextStyle(color: AppColors.blackColor,fontSize: 14.sp),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(
      {
        TimeOfDay? selectedTime,
        VoidCallback? onTap,
        required String hint
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.whiteColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
          child: Row(
            children: [
              Icon(Icons.access_time, color: AppColors.primaryColor),
              SizedBox(width: 10.w,),
              CustomText(
                selectedTime == null
                    ? hint
                    : selectedTime.format(context),
                textStyle: TextStyle(color: AppColors.blackColor,fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
