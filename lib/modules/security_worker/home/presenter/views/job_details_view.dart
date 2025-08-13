import 'package:doors/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_strings.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../home/infra/models/job_model.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage({super.key, required this.job});
  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.whiteColor),
        backgroundColor: AppColors.primaryColor,
        title: CustomText(
          "Job Details",
          textStyle: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        actions: [

          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share, color: AppColors.whiteColor),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.bookmark_add_outlined, color: AppColors.whiteColor),
          ),

        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withOpacity(.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Section
                _buildHeader().paddingSymmetricV(25.h),
                 Divider(),
                
                /// Job Details Section
                _buildJobDetails().paddingSymmetricV(25.h),
                Divider(),

               /// Full Job Description
                _buildJobDescription().paddingSymmetricV(25.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainHeading(headingText: job.jobTitle!),
        _iconText(icon: Icons.apartment_rounded,title: job.companyName!),
        SizedBox(height: 8.h),
        _iconText(icon: Icons.location_on_outlined, title: job.address!),
      ],
    ).paddingSymmetricH(15.w);
  }

  Widget _buildJobDetails(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainHeading(headingText: "Job Details"),
         Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children : [
             Icon(Icons.payments_outlined,color: AppColors.greyColor,),
             SizedBox(width: 15.w),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [

                 CustomText("Pay",textStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500),),
                 SizedBox(height: 5.h,),
                 Container(
                   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                   decoration: BoxDecoration(
                     color: AppColors.lightGreenColor,
                     borderRadius: BorderRadius.circular(5.r),
                   ),
                   child: CustomText(
                     "${AppStrings.rupeeSign}${job.salary}/month",
                     textStyle: TextStyle(
                       fontSize: 12.sp,
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                 ),
               ],
             )
          ]
        ),
         SizedBox(height: 15.h,),
         Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children : [
              Icon(Icons.work,color: AppColors.greyColor,),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  CustomText("Job Type",textStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500),),
                  SizedBox(height: 5.h,),

                  Wrap(
                    children: List.generate(2, (index){
                      return Container(
                        margin: EdgeInsets.only(right: 8.w),
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreenColor,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: CustomText(
                          "Permanent",
                          textStyle: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }),
                  )

                ],
              )
            ]
        ),
      ],
    ).paddingSymmetricH(15.w);
  }
  
  Widget _buildJobDescription(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainHeading(headingText: "About the Role"),

        CustomText(job.description!,maxLines: 100,height: 1.5,fontSize: 15.sp,color: AppColors.greyColor,).paddingBottom(15.h),

        _buildMainHeading(headingText: "Requirements"),
      ],
    ).paddingSymmetricH(15.w);
  }
  Widget _buildMainHeading({required String headingText}){
    return CustomText(
      headingText,
      maxLines: 2,
      textStyle: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryColor,
        height: 1.15,
      ),
    ).paddingBottom(15.h);
  }

  Widget _iconText({required IconData icon, required String title, TextStyle? titleStyle}) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.greyColor),
        SizedBox(width: 5.w),
        Expanded(
          child: CustomText(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textStyle: titleStyle ?? TextStyle(color: AppColors.blackColor,fontSize: 16.sp),
          ),
        ),
      ],
    );
  }


}



class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          child,
        ],
      ),
    );
  }
}



Widget _buildBullets({required List<String> items}){
  return Column(
    children: items.map((e) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText('•  '),
            Expanded(child: CustomText(e, textStyle: const TextStyle(height: 1.35))),
          ],
        ),
      );
    }).toList(),
  );
}

Widget _buildChips({required List<String> items}){
  return Wrap(
    spacing: 8.w,
    runSpacing: 8.h,
    children: items
        .map((e) => Chip(
      label: Text(e),
      backgroundColor: AppColors.backGroundColor,
      side: BorderSide(color: AppColors.primaryColor.withOpacity(.25)),
    )).toList(),
  );
}

