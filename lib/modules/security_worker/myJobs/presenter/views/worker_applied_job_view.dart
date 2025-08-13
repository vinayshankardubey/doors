import 'package:doors/modules/security_worker/myJobs/presenter/widgets/worker_applied_job_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../widgets/custom_text.dart';
import '../controllers/provider/worker_my_job_provider.dart';

class WorkerAppliedJobView extends StatefulWidget {
  const WorkerAppliedJobView({super.key});

  @override
  State<WorkerAppliedJobView> createState() => _WorkerAppliedJobViewState();
}

class _WorkerAppliedJobViewState extends State<WorkerAppliedJobView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<WorkerMyJobProvider>().fetchAppliedJobData();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
              child: Consumer<WorkerMyJobProvider>(
                builder: (context, workerMyJobProvider, child) {
                  return workerMyJobProvider.appliedJobData.isNotEmpty
                   ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "Applied Jobs",
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      /// Job Listings
                      workerMyJobProvider.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                            workerMyJobProvider.appliedJobData.length,
                            itemBuilder: (BuildContext context, int index) {
                            final appliedJobData =
                            workerMyJobProvider.appliedJobData[index];
                            return WorkerAppliedJobCard(jobData: appliedJobData);
                        },
                      ),
                      SizedBox(height: 20.h,),
                    ],
                  )
                   : Center(child: CustomText("No More Jobs"));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

}
