import 'package:doors/core/routes/app_routes.dart';
import 'package:doors/modules/authentication/presenter/controllers/providers/auth_provider.dart';
import 'package:doors/supabase/supabase_client.dart';
import 'package:doors/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_strings.dart';
import '../../../../core/utils.dart';
import '../../../../widgets/custom_animated_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Consumer<AuthProvider>(
            builder: (context,authProvider,child) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),

                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 100.h),
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

                    /// Welcome Back Text
                    CustomText(
                      "Welcome Back",
                      textStyle: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.h),
                    CustomText(
                      AppStrings.loginToYourAccountToContinue,
                      textStyle: TextStyle(fontSize: 15, color: AppColors.greyColor),
                    ),
                    SizedBox(height: 30.h),

                    /// Email field
                    TextFormField(
                      controller:authProvider.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: authProvider.validateEmail,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        hintText: AppStrings.email,
                        hintStyle: TextStyle(
                            color: AppColors.greyColor
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    /// Password field
                    TextFormField(
                      controller: authProvider.passwordController,
                      obscureText: authProvider.obscure,
                      validator: authProvider.validatePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        hintText: AppStrings.password,
                        hintStyle: TextStyle(
                            color: AppColors.greyColor
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(authProvider.obscure ? Icons.visibility_off : Icons.visibility),
                          onPressed: (){
                          authProvider.obscure = !authProvider.obscure;
                          authProvider.update();
                        } ,
                        ),
                        filled: true,
                        fillColor: AppColors.whiteColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 25.h),

                    /// Login button
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: CustomAnimatedButton(
                        text: AppStrings.login,
                        isLoading: authProvider.isLoading,
                        textStyle:  TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor,
                        ),
                        backgroundColor: AppColors.darkBlueColor,
                        onPressed: () async{
                          if(_formKey.currentState!.validate()){
                            await authProvider.login();
                          }else{
                            Utils.showToast(msg: "Please fill all the fields");
                          }
                        },
                      ),
                    ),


                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(AppStrings.dontHaveAccount),
                        TextButton(
                          onPressed: () {
                            Utils.navigateTo(AppRoutes.signUpView);
                          },
                          child: CustomText(
                            AppStrings.signUp,
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
            }
          ),
        ),
      ),
    );
  }
}
