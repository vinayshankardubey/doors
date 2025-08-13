import 'package:doors/core/constant/app_colors.dart';
import 'package:doors/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../supabase/supabase_client.dart';
import '../../../../supervisor/profile/presenter/controllers/profile_provider.dart';

class WorkerProfileView extends StatefulWidget {
  const WorkerProfileView({super.key});

  @override
  State<WorkerProfileView> createState() => _WorkerProfileViewState();
}

class _WorkerProfileViewState extends State<WorkerProfileView> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: CustomText("My Profile",textStyle: TextStyle(fontSize: 16.sp,color: AppColors.whiteColor),),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Consumer<ProfileProvider>(
          builder: (context,profileProvider,child) {
            final userData = profileProvider.userProfileData!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        // backgroundImage: NetworkImage(
                        //   "https://i.pravatar.cc/150?img=47", // Replace with user's image
                        // ),
                        child: Icon(Icons.person,size: 80,),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: theme.primaryColor,
                          child: const Icon(Icons.edit, size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),

                /// Name & Title
                CustomText(userData.name!, textStyle:TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp)),
                SizedBox(height: 5.h),
                CustomText("UI/UX Designer", textStyle: theme.textTheme.bodyMedium?.copyWith(color: AppColors.greyColor)),

                SizedBox(height: 20.h),

                /// Personal Info
                _buildInfoTile(icon: Icons.email, title: "Email", value: userData.email!),
                _buildInfoTile(icon: Icons.phone, title: "Phone", value: "+91 ${userData.phoneNumber}"),
                _buildInfoTile(icon: Icons.location_on, title: "Location", value: "${userData.address}"),

                SizedBox(height: 20.h),

                /// Resume & Documents
                _buildSectionTitle(title: "Resume & Documents"),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text("My Resume.pdf"),
                  trailing: const Icon(Icons.download_rounded),
                  onTap: () {
                    // Handle download/open
                  },
                ),
                SizedBox(height: 20.h),

                /// Skills
                _buildSectionTitle(title: "Skills"),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ["Figma", "Flutter", "Firebase", "HTML", "Communication"]
                      .map((skill) => Chip(
                    label: Text(skill),
                    backgroundColor: theme.primaryColor.withOpacity(0.1),
                  ))
                      .toList(),
                ),

              SizedBox(height: 20.h),

                /// Experience
                _buildSectionTitle(title: "Experience"),
                _buildExperienceTile(
                  title: "Junior UI/UX Designer",
                  company: "TechSmart Pvt. Ltd.",
                  duration: "Jan 2023 - Present",
                ),
                _buildExperienceTile(
                  title: "Design Intern",
                  company: "Softlogics",
                  duration: "Jul 2022 - Dec 2022",
                ),
                SizedBox(height: 30.h),

                /// Edit & Logout Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // Navigate to edit
                      },
                      icon: const Icon(Icons.edit),
                      label: CustomText("Edit Profile",textStyle: TextStyle(fontSize: 14.sp),),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        SupabaseManager.logout(context);
                      },
                      icon: const Icon(Icons.logout),
                      label: CustomText("Logout",textStyle: TextStyle(fontSize: 14.sp)),
                    ),
                  ],
                ),
               SizedBox(height: 20.h),
              ],
            );
          }
        ),
      ),
    );


  }


  Widget _buildInfoTile({required IconData icon, required String title, required String value}){
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.blueGrey),
      title: CustomText(title, textStyle: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: CustomText(value,textStyle: TextStyle(fontSize: 13.sp,color: AppColors.greyColor),),
    );
  }

  Widget _buildSectionTitle({required String title}){
    return  Align(
      alignment: Alignment.centerLeft,
      child: CustomText(title,
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildExperienceTile({required String title, required String company, required String duration}){
    return  ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.work_outline),
      title: CustomText(title),
      subtitle: CustomText("$company • $duration", textStyle: TextStyle(fontSize: 14.sp,color: AppColors.greyColor),),
    );
  }

}
