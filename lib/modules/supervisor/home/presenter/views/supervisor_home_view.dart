import 'package:doors/core/routes/app_routes.dart';
import 'package:doors/core/utils.dart';
import 'package:doors/widgets/custom_animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../supabase/supabase_client.dart';
import '../../../../../widgets/custom_text.dart';

class SupervisorHomeView extends StatefulWidget {
  const SupervisorHomeView({super.key});

  @override
  State<SupervisorHomeView> createState() => _SupervisorHomeViewState();
}

class _SupervisorHomeViewState extends State<SupervisorHomeView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        title: CustomText(
          "DOORS",
          textStyle: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              SupabaseManager.logout(context);
            },
            icon: Icon(Icons.logout_outlined, color: AppColors.whiteColor),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {

          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Header Section of dashboard
                _buildHeaderSection(),
                SizedBox(height: 16.h),

                /// Stats Card of dashboard
                _buildStatCards(),
                SizedBox(height: 16.h),

                /// Recent job Section
                CustomText(
                  "Recent Jobs",
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildRecentJobList(),
                SizedBox(height: 24.h),


              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 60.h,
        child: CustomAnimatedButton(
          backgroundColor: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10.r),
            text: "Post Job",
            onPressed: (){
             Utils.navigateTo(AppRoutes.jobPostView);
            }
        ).paddingOnly(left: 20,right: 20,bottom: 10),
      ),
    );
  }

  Widget _buildHeaderSection() {
    final now = DateTime.now();
    final formattedDate = "${now.day}/${now.month}/${now.year}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "Good morning",
          textStyle: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        CustomText(
          "Date: $formattedDate",
          textStyle: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard("Total Jobs", "24", Icons.work),
        SizedBox(width: 8.w),
        _buildStatCard("Pending", "6", Icons.pending_actions),
        SizedBox(width: 8.w),
        _buildStatCard("Workers", "12", Icons.group),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        elevation: 2,
        color: AppColors.primaryColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.whiteColor, size: 24.sp),
              SizedBox(height: 8.h),
              CustomText(
                value,
                textStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
              ),
              CustomText(
                title,
                textStyle: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentJobList() {
    final jobs = [
      {"title": "Mall Security", "location": "Lucknow"},
      {"title": "Warehouse Night Shift", "location": "Kanpur"},
    ];

    return Column(
      children: jobs.map((job) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: ListTile(
            title: Text(job['title']!),
            subtitle: Text(job['location']!),
            trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
            onTap: () {
              // TODO: Navigate to job detail screen
            },
          ),
        );
      }).toList(),
    );
  }
}
