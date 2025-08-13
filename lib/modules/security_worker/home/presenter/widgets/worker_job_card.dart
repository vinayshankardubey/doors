import 'package:doors/core/routes/app_routes.dart';
import 'package:doors/core/utils.dart';
import 'package:doors/modules/security_worker/home/infra/models/job_model.dart';
import 'package:doors/modules/security_worker/home/presenter/controllers/provider/worker_home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_strings.dart';
import '../../../../../widgets/custom_animated_button.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../myJobs/presenter/controllers/provider/worker_my_job_provider.dart';

class WorkerJobCard extends StatelessWidget {
  final JobModel jobData;
  final WorkerHomeProvider workerHomeProvider;
  const WorkerJobCard({
    super.key,
    required this.jobData,
    required this.workerHomeProvider,

  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkerMyJobProvider>(
      builder: (context,workerMyJobProvider,child) {
        final isApplied = workerMyJobProvider.checkJobApplied(jobId: jobData.jobId!);
        final isApplying = workerMyJobProvider.isApplying(jobId: jobData.jobId!);
        final isSaved   = workerMyJobProvider.checkJobSaved(jobId: jobData.jobId!);

        return InkWell(
          onTap: (){
            Utils.navigateToWithData(AppRoutes.jobDetailsPage, jobData);
          },
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Job Title + Salary Badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText(
                            jobData.jobTitle ?? '',
                            maxLines: 3,
                            textStyle: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.lightGreenColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: CustomText(
                            "${AppStrings.rupeeSign}${jobData.salary}/month",
                            textStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ).paddingBottom(10.h),

                    /// Company Name
                    _buildIconTitle(icon: Icons.apartment_rounded, title: jobData.companyName ?? '',titleStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.sp)).paddingBottom(8.h),

                    /// Address
                    _buildIconTitle(icon: Icons.location_on_outlined, title: jobData.address ?? '', ).paddingBottom(12.h),

                    /// Timing
                    _buildIconTitle(icon: Icons.access_time, title: "Timing: 10AM – 6PM", ).paddingBottom(20.h),

                    /// Apply Button + Bookmark
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // APPLY / APPLIED
                    CustomAnimatedButton(
                      isLoading: isApplying,
                      borderRadius: BorderRadius.circular(12.r),
                      backgroundColor: isApplied
                          ? AppColors.primaryColor.withOpacity(.5)
                          : AppColors.primaryColor,
                      text: isApplied ? "Applied" : "Apply Now",
                      textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteColor,
                      ),
                      onPressed: (!isApplied && !isApplying)
                            ? () async {
                            await workerMyJobProvider.applyJob(jobId: jobData.jobId!);
                           }
                          : (){},
                    ),

                    SizedBox(width: 12.w),

                    // SAVE / UNSAVED

                    InkWell(
                        onTap: isSaved
                            ? ()async{
                              await workerMyJobProvider.removeSavedJob(jobId: jobData.jobId!);
                             }
                            : () {workerMyJobProvider.saveJob(jobId: jobData.jobId!);},
                        child: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved ? AppColors.primaryColor : AppColors.greyColor
                           )
                      ),

                    ],
                   )
                  ],
                ),
              ),
            ),
        );
      }
    );
  }

  Widget _buildIconTitle({
    required IconData icon,
    Color iconColor = AppColors.greyColor,
    required String title,
    TextStyle? titleStyle

  }){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.sp, color: iconColor),
        SizedBox(width: 6.w),
        Expanded(
          child: CustomText(
            title,
            maxLines: 5,
            textStyle:  titleStyle ?? TextStyle(
              height: 1.3,
              fontSize: 14.sp,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
