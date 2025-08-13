import 'package:doors/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../widgets/custom_text.dart';
import '../../infra/models/saved_job_model.dart';

class WorkerAppliedJobCard extends StatelessWidget {
  final SavedJobModel? jobData;
  final VoidCallback? onViewApplication;

  const WorkerAppliedJobCard({
    super.key,
    this.jobData,
    this.onViewApplication,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Safe fallbacks
    final title = jobData?.job?.jobTitle ?? 'Job Title';
    final company = jobData?.job?.companyName ?? 'Company';
    final address = jobData?.job?.address ?? 'Location';
    final salary = jobData?.job?.salary ?? '';
    final statusStyle = _statusChipStyle(jobData!.status!, theme);
    final appliedTime = _formatRelative(DateTime.parse(jobData!.createdAt!));

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: statusStyle.borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            CircleAvatar(
              radius: 24.r,
              child: const Icon(Icons.work_outline) ,
            ),
            SizedBox(width: 10.w),

            // Text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Status chip
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          title,
                          maxLines: 3,
                          textStyle: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                            height: 1.15,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _StatusChip(
                        label: statusStyle.label,
                        bg: statusStyle.bg,
                        fg: statusStyle.fg,
                        icon: statusStyle.icon,
                      ),
                    ],
                  ).paddingBottom(8.h),

                  _buildIconTitle(
                    title: company,
                    icon: Icons.apartment_rounded,
                    titleStyle: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ).paddingBottom(6.h),

                  _buildIconTitle(
                    title: address,
                    icon: Icons.location_on_outlined,
                  ).paddingBottom(6.h),

                  if (salary.isNotEmpty)
                    _buildIconTitle(
                      title: "$salary / Month",
                      icon: Icons.currency_rupee,
                    ).paddingBottom(6.h),

                  _buildIconTitle(
                    title:  'Applied • $appliedTime',
                    icon: Icons.schedule,
                  ).paddingBottom(10.h),

                  // Actions
                  Row(
                    children: [
                      // View / Track
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onViewApplication,
                          icon: const Icon(Icons.visibility_outlined, size: 18),
                          label: const Text('View Application'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 12.w),
                            side: BorderSide(color: AppColors.primaryColor),
                            foregroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatRelative(DateTime? dt) {
    if (dt == null) return '—';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.bg,
    required this.fg,
    required this.icon,
  });

  final String label;
  final Color bg;
  final Color fg;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: fg),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusStyle {
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  final Color borderColor;

  _StatusStyle(
      this.label, this.icon, this.bg, this.fg, this.borderColor);
}

_StatusStyle _statusChipStyle(String status, ThemeData theme) {
  final lc = status.toLowerCase().trim();
  if (lc.contains('reject')) {
    return _StatusStyle(
      'Rejected',
      Icons.cancel_rounded,
      AppColors.errorColor.withOpacity(.08),
      AppColors.errorColor,
      AppColors.errorColor.withOpacity(.25),
    );
  }
  if (lc.contains('interview')) {
    return _StatusStyle(
      'Interview',
      Icons.event_available_rounded,
      AppColors.primaryColor.withOpacity(.08),
      AppColors.primaryColor,
      AppColors.primaryColor.withOpacity(.25),
    );
  }
  if (lc.contains('review') || lc.contains('screen')) {
    return _StatusStyle(
      'Under Review',
      Icons.hourglass_bottom_rounded,
      AppColors.amberColor.withOpacity(.15),
      AppColors.amberColor,
      AppColors.amberColor.withOpacity(.35),
    );
  }
  // default: Applied
  return _StatusStyle(
    'Applied',
    Icons.check_circle_rounded,
    AppColors.successColor.withOpacity(.10),
    AppColors.successColor,
    AppColors.successColor.withOpacity(.25),
  );
}

/// Reusable icon + title line
Widget _buildIconTitle({
  required IconData icon,
  Color iconColor = AppColors.primaryColor,
  required String title,
  TextStyle? titleStyle,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 18.sp, color: iconColor),
      SizedBox(width: 6.w),
      Expanded(
        child: CustomText(
          title,
          maxLines: 5,
          textStyle: titleStyle ??
              TextStyle(
                height: 1.3,
                fontSize: 14.sp,
                color: AppColors.greyColor,
              ),
        ),
      ),
    ],
  );
}
