import 'package:doors/modules/security_worker/myJobs/presenter/views/worker_applied_job_view.dart';
import 'package:doors/modules/security_worker/myJobs/presenter/views/worker_saved_job_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../widgets/custom_text.dart';
import '../controllers/provider/worker_my_job_provider.dart';

class WorkerMyJobView extends StatefulWidget {
  const WorkerMyJobView({super.key});

  @override
  State<WorkerMyJobView> createState() => _WorkerMyJobViewState();
}

class _WorkerMyJobViewState extends State<WorkerMyJobView> {
  late WorkerMyJobProvider workerMyJobProvider;

  @override
  void initState() {
    super.initState();
    workerMyJobProvider = context.read<WorkerMyJobProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      workerMyJobProvider.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor:  AppColors.backGroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          title:  CustomText("My Jobs", textStyle: TextStyle(color: AppColors.whiteColor,fontWeight: FontWeight.bold)),
        ),

        body: Column(
          children: [
            TabBar(

             labelStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
              tabs: [
                Tab(text: "Saved Jobs"),
                Tab(text: "Applied Jobs"),
              ],
            ),

            Expanded(
                child: TabBarView(
                    children: [
                      WorkerSavedJobView(),
                      WorkerAppliedJobView(),
                   ]
                )
            )
          ],
        ),
      ),
    );
  }
}
