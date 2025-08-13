import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../widgets/custom_text.dart';
import '../controllers/provider/worker_my_job_provider.dart';
import '../widgets/worker_saved_job_card.dart';

class WorkerSavedJobView extends StatefulWidget {
  const WorkerSavedJobView({super.key});

  @override
  State<WorkerSavedJobView> createState() => _WorkerSavedJobViewState();
}

class _WorkerSavedJobViewState extends State<WorkerSavedJobView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<WorkerMyJobProvider>().fetchSavedJobData();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
              child: Consumer<WorkerMyJobProvider>(
                builder: (context, workerMyJobProvider, child) {
                  return workerMyJobProvider.savedJobData.isNotEmpty
                   ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      CustomText(
                        "Saved Jobs",
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      /// Job Listings
                      workerMyJobProvider.isSavedJobLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                            workerMyJobProvider.savedJobData.length,
                            itemBuilder: (BuildContext context, int index) {
                              final savedJobData =
                              workerMyJobProvider.savedJobData[index];
                              return  WorkerSavedJobCard(
                                    jobData: savedJobData,
                                    onTap: (){},
                                    onUnSave: (){},
                                    );
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
