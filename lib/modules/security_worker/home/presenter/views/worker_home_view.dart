import 'package:doors/core/constant/app_strings.dart';
import 'package:doors/widgets/custom_animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../supabase/supabase_client.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../../supervisor/profile/presenter/controllers/profile_provider.dart';
import '../../../myJobs/presenter/controllers/provider/worker_my_job_provider.dart';
import '../../infra/models/job_model.dart';
import '../controllers/provider/worker_home_provider.dart';
import '../widgets/job_filter_bottom_sheet.dart';
import '../widgets/worker_job_card.dart';

class WorkerHomeView extends StatefulWidget {
  const WorkerHomeView({super.key});

  @override
  State<WorkerHomeView> createState() => _WorkerHomeViewState();
}

class _WorkerHomeViewState extends State<WorkerHomeView> {
  late ProfileProvider profileProvider;
  late WorkerHomeProvider workerHomeProvider;
  late WorkerMyJobProvider workerMyJobProvider;
  @override
  void initState() {
    super.initState();
    profileProvider = context.read<ProfileProvider>();
    workerHomeProvider = context.read<WorkerHomeProvider>();
    workerMyJobProvider = context.read<WorkerMyJobProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      await workerMyJobProvider.init();
      workerHomeProvider.init();
      profileProvider.fetchUserProfileData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  AppColors.backGroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        title:  CustomText("DOORS", textStyle: TextStyle(color: AppColors.whiteColor,fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              onPressed: (){
                SupabaseManager.logout(context);
                // Utils.navigateTo(AppRoutes.userRegistrationView);
              },
              icon: Icon(Icons.logout_outlined, color : AppColors.whiteColor)
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()async{
            await workerHomeProvider.fetchJobData();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.only(left: 10.w,right: 10.w),
              child: Consumer<WorkerHomeProvider>(
                builder: (context,workerHomeProvider,child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h,),
                      /// 🔍 Search Bar
                      _buildSearchSection(),

                      const SizedBox(height: 20),

                      ///Job Categories
                      SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                             Chip(label: CustomText("All")),
                             Spacer(),
                             IconButton(onPressed: (){
                               jobFilterBottomSheet(context: context);
                             }, icon: Icon(Icons.filter_alt))
                          ],
                        )
                      ),

                      const SizedBox(height: 20),
                      CustomText(
                        "Recommended Jobs",
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      /// Job Listings
                      workerHomeProvider.isLoading
                          ?  Center(child: CircularProgressIndicator(),)
                       : ListView.builder(
                         shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: workerHomeProvider.allJobData.length,
                        itemBuilder: (ctx, index){
                          final data = workerHomeProvider.allJobData[index];
                          return
                            workerHomeProvider.allJobData.isNotEmpty
                                 ? WorkerJobCard(jobData: data,workerHomeProvider: workerHomeProvider,)
                                 : CustomText("No More Jobs");
                        },
                      ),
                    ],
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(){
    return Card(
      shadowColor: AppColors.lightGreyColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search job",
                prefixIcon: const Icon(Icons.search,color: AppColors.primaryColor,),
                filled: true,
                fillColor: AppColors.whiteColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),topRight: Radius.circular(10.r)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Divider(color: AppColors.lightGreyColor,height: 0.h,),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText:  "Search city or state",
                prefixIcon: const Icon(Icons.location_on_outlined,color: AppColors.primaryColor,),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r),bottomRight: Radius.circular(10.r)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
