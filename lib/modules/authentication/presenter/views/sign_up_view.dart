import 'package:doors/core/routes/app_routes.dart';
import 'package:doors/modules/authentication/presenter/controllers/providers/auth_provider.dart';
import 'package:doors/widgets/custom_animated_button.dart';
import 'package:doors/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_strings.dart';
import '../../../../core/utils.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Header Section
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 80.h),
                          CustomText(
                            "DOORS",
                            textStyle: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: AppColors.darkBlueColor,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          CustomText(
                            AppStrings.secureJobsRealOpportunities,
                            textStyle: TextStyle(fontSize: 14, color: AppColors.greyColor),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40.h),

                    /// Heading
                    CustomText(
                      "Create Account",
                      textStyle: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.h),
                    CustomText(
                      AppStrings.registerToGetStarted,
                      textStyle: TextStyle(fontSize: 15, color: AppColors.greyColor),
                    ),
                    SizedBox(height: 30.h),

                    /// Full Name
                    TextFormField(
                      controller: authProvider.fullNameController,
                      decoration: InputDecoration(
                      hintText: "Full Name",
                        hintStyle: TextStyle(
                            color: AppColors.greyColor
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    TextFormField(
                      controller: authProvider.phoneNumberController,
                      validator: authProvider.validatePhoneNumber,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: AppStrings.mobileNumber,
                        hintStyle: TextStyle(
                          color: AppColors.greyColor
                        ),
                        prefixIcon: const Icon(Icons.phone_android_outlined),
                        filled: true,
                        fillColor: AppColors.whiteColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    /// Email
                    TextFormField(
                      controller: authProvider.emailController,
                      validator: authProvider.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: AppStrings.email,
                        hintStyle: TextStyle(
                            color: AppColors.greyColor
                        ),
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: AppColors.whiteColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    /// Password
                    TextFormField(
                      controller: authProvider.passwordController,
                      obscureText: authProvider.obscure,
                      validator: authProvider.validatePassword,
                      decoration: InputDecoration(
                        hintText: AppStrings.password,
                        hintStyle: TextStyle(
                            color: AppColors.greyColor
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(authProvider.obscure ? Icons.visibility_off : Icons.visibility),
                          onPressed: (){
                            authProvider.obscure = !authProvider.obscure;
                            authProvider.update();
                          }
                        ),
                        filled: true,
                        fillColor: AppColors.whiteColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),

                    /// Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: CustomAnimatedButton(
                        text: AppStrings.signUp,
                        isLoading: authProvider.isLoading,
                        textStyle:  TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                        ),
                        backgroundColor: AppColors.darkBlueColor,
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            authProvider.signUp();
                          }else{
                            debugPrint("Please fill all the fields");
                          }
                        },
                      ),
                    ),

                    SizedBox(height: 15.h),

                    /// Login Navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(AppStrings.alreadyHaveAccount),
                        TextButton(
                          onPressed: () => Utils.navigateTo(AppRoutes.loginView),
                          child: CustomText(
                            "Login",
                            textStyle: TextStyle(
                              color: AppColors.darkBlueColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
