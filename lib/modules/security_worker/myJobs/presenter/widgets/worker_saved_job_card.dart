import 'package:doors/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../widgets/custom_text.dart';
import '../../infra/models/saved_job_model.dart';

class WorkerSavedJobCard extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onUnSave;
  final SavedJobModel? jobData;

  const WorkerSavedJobCard({
    super.key,
    this.onTap,
    this.onUnSave,
    this.jobData
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24.r,
                child: const Icon(Icons.work)
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    CustomText(
                      jobData!.job!.jobTitle!,
                      maxLines: 3,
                      textStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ).paddingBottom(10.h),

                    _buildIconTitle(title: jobData!.job!.companyName!,icon: Icons.apartment_rounded,titleStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)).paddingBottom(5.h),
                    _buildIconTitle(title: jobData!.job!.address!,icon: Icons.location_on,).paddingBottom(5.h),
                    _buildIconTitle(title: "${jobData!.job!.salary!}/Month",icon: Icons.currency_rupee,).paddingBottom(5.h),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Remove from saved',
                onPressed: onUnSave,
                icon: const Icon(Icons.bookmark_remove),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatRelative(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

Widget _buildIconTitle({
  required IconData icon,
  Color iconColor = AppColors.primaryColor,
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
