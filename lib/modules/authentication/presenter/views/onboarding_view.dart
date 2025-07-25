import 'package:doors/core/constant/app_colors.dart';
import 'package:doors/core/constant/app_strings.dart';
import 'package:doors/core/utils.dart';
import 'package:doors/modules/authentication/presenter/controllers/providers/auth_provider.dart';
import 'package:doors/widgets/custom_animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/app_images.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../widgets/custom_text.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context,authProvider,child) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: authProvider.pageController,
                        itemCount: authProvider.pages.length,
                        onPageChanged: (index) {
                           authProvider.updatePageIndex(index);
                        },
                        itemBuilder: (context, index) {
                          final page = authProvider.pages[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 320.h,
                                    child: Image.asset(page["image"],fit: BoxFit.contain,)
                                ),
                                SizedBox(height: 40.h),
                                CustomText(
                                  page["title"],
                                  textStyle: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blackColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 15.h),
                                CustomText(
                                  page["subtitle"],
                                  maxLines: 3,
                                  textAlign: TextAlign.start,
                                  textStyle: TextStyle(
                                    fontSize: 15.sp,
                                    color: AppColors.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        authProvider.pages.length,
                            (index) => Container(
                          margin: EdgeInsets.all(4.r),
                          width: authProvider.currentPage == index ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: authProvider.currentPage == index ? Colors.black : Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.h,vertical: 10.h),
                      child: CustomAnimatedButton(
                        padding: EdgeInsets.symmetric(vertical: 13.h),
                          text: authProvider.currentPage == authProvider.pages.length - 1
                              ? AppStrings.getStarted
                              : AppStrings.next,
                          onPressed: (){
                            if(authProvider.currentPage == authProvider.pages.length - 1){
                             Utils.navigateToOffAll(AppRoutes.loginView);
                            }else{
                              authProvider.pageController.nextPage(
                                duration: const Duration(milliseconds: 300), curve: Curves.easeInOut,);
                            }
                          }
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
                
                Positioned(
                    top: 20.h,
                    right: 20.w,
                    child: InkWell(
                        onTap: (){
                          authProvider.pageController.animateToPage(
                            authProvider.pages.length - 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: CustomText("Skip",
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500),
                        )
                    )
                )
              ],
            );
          }
        ),
      ),
    );
  }
}
