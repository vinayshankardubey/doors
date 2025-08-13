import 'package:doors/widgets/custom_animated_button.dart';
import 'package:doors/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/utils.dart';
import '../../infra/models/user_profile_data_model.dart';
import '../controllers/providers/auth_provider.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
     context.read<AuthProvider>().fetchCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  CustomText("Complete Your Profile",textStyle: TextStyle(fontSize: 16.sp),)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            curve: Curves.easeOut,
            child:  SingleChildScrollView(
              padding:  EdgeInsets.all(20.r),
              child:  ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Consumer<AuthProvider>(
                    builder: (context,authProvider,child) {
                      return Column(
                        children: [
                          _buildField(
                              label:  "Full Name",
                              controller: authProvider.fullNameController,
                              icon: Icons.person_outline,
                          ),
                          _buildField(
                              label:  "Address",
                              controller: authProvider.addressController,
                              icon: Icons.home_outlined,
                          ),
                          _buildField(
                              label:  "License Number",
                              controller:authProvider.licenseController,
                              icon: Icons.badge_outlined,
                          ),
                          _buildField(
                              label: "Enhanced DBS Certificate No.",
                              controller:authProvider.dbsCertificateController,
                              icon: Icons.verified_user_outlined,
                          ),
                          _buildField(
                              label: "Driver’s License Number",
                              controller: authProvider.driverLicenseController,
                              icon: Icons.car_rental_outlined,
                          ),
                          _buildField(
                              label: "UTR Number",
                              controller:authProvider.utrController,
                              icon: Icons.numbers_outlined,

                          ),
                        ],
                      );
                    }
                  ),
                ),
              ),
            ),
          );
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:  Consumer<AuthProvider>(
        builder: (context,authProvider,child) {
          return Container(
            height: 50.h,
            margin: EdgeInsets.only(bottom: 20.h,left : 20.w,right : 20.w),
            child: CustomAnimatedButton(
                borderRadius: BorderRadius.circular(10.r),
                backgroundColor: AppColors.primaryColor,
                isLoading: authProvider.isLoading,
                text: "Submit",
                onPressed: () async{
                  if(authProvider.checkFieldEmptyOrNot()){
                    Utils.showToast(msg: "Please fill all the fields");
                  }else{
                    UserProfileDataModel userProfileDataModel = UserProfileDataModel(
                      name: authProvider.fullNameController.text.trim(),
                      address: authProvider.addressController.text.trim(),
                      licenseNumber: authProvider.licenseController.text.trim(),
                      dbsCertificateNumber: authProvider.dbsCertificateController.text.trim(),
                      driverLicenseNumber: authProvider.driverLicenseController.text.trim(),
                      utrNumber: authProvider.utrController.text.trim(),
                      latitude: authProvider.locationPosition!.latitude.toString(),
                      isSupervisor: false,
                      longitude: authProvider.locationPosition!.longitude.toString(),
                    );
                    await authProvider.insertUserProfileData(userProfileDataModel: userProfileDataModel);
                  }
                }
            ),
          );
        }
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon,color: AppColors.primaryColor),
          labelText: label,
          filled: true,
          fillColor: AppColors.whiteColor,
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.greyColor.withOpacity(.5))
          ),
          focusedBorder:  OutlineInputBorder(
           borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.primaryColor)
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.greyColor.withOpacity(.5))
          ),
        ),
      ),
    );
  }
}
