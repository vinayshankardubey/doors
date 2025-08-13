import 'dart:core';
import 'dart:io';
import 'package:doors/core/database/local_database.dart';
import 'package:doors/core/database/local_db_keys.dart';
import 'package:doors/core/routes/app_routes.dart';
import 'package:doors/core/utils.dart';
import 'package:doors/supabase/supabase_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../core/constant/app_images.dart';
import '../../../../../../core/services/geolocator_services.dart';
import '../../../infra/models/user_profile_data_model.dart';

class AuthProvider extends ChangeNotifier{
  // Controllers
  final PageController pageController = PageController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController dbsCertificateController = TextEditingController();
  final TextEditingController driverLicenseController = TextEditingController();
  final TextEditingController utrController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController sortCodeController = TextEditingController();


  final supabaseClient = SupabaseManager.supabaseClient;
  bool obscure = true;
  bool _isLoading = false;
  int currentPage = 0;
  Position? locationPosition;


  final List<Map<String,dynamic>> pages = [
    {
      "title": 'Find Jobs Near You',
      "subtitle": 'Explore security jobs in your area with real-time updates.',
      "image": AppImages.onBoardingImg1,
    },
    {
      "title": 'Apply Instantly',
      "subtitle": 'Tap and apply to jobs that match your skills and location.',
      "image": AppImages.onBoardingImg2,
    },
    {
      "title": 'Get Hired Fast',
      "subtitle": 'Track applications, confirm jobs, and start working quickly.',
      "image": AppImages.onBoardingImg3,
    }
  ];

  bool get isLoading => _isLoading;

  void update(){
    notifyListeners();
  }

  // update page index
  void updatePageIndex(int index){
    currentPage = index;
    update();
  }

  Future<void> signUp()async{
    try{
      _isLoading = true;
      update();
      final response = await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),);
      if (response.user != null) {
           final responseData = await SupabaseManager.supabaseClient.from("user_profile").insert({
             "name" : fullNameController.text.trim(),
             "email" : emailController.text.trim(),
             "phone_number" : phoneNumberController.text.trim(),
             "user_id" : response.user!.id
           }).select();
           if(responseData!=null && responseData.isNotEmpty){
             debugPrint("User data inserted successfully $responseData");
           }else{
             debugPrint("User data insertion failed $responseData");
           }
           clearControllers();
           LocalDatabase.saveBool(key: LocalDbKeys.isSignedUp, value: true);
           debugPrint("Signed up Successfully: ${response.user!.email}");
           Utils.showToast(msg: "Confirmation email sent on ${response.user!.email}");
           Utils.navigateToOffAll(AppRoutes.loginView);
      } else {
        debugPrint("Error: occurred");
      }
    } on AuthException catch (ex) {
      Utils.showToast(msg: ex.message);
    } catch (ex){
      debugPrint("Exception occurred while signup $ex");
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login() async {
    try{
      _isLoading = true;
      update();

      final response = await SupabaseManager.supabaseClient.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (response.user != null) {
        debugPrint("Logged in Successfully: ${response.user!.email}");
        await checkUserRegistrationStatus();
        clearControllers();
      } else {
        debugPrint("Login error: $response");
      }
    } on AuthException catch (ex) {
      Utils.showToast(msg: ex.message);
    } catch (ex){
      debugPrint("Exception occurred while login $ex");
    }finally{
      _isLoading = false;
      notifyListeners();
    }

  }

  Future<void> insertUserProfileData({
    required UserProfileDataModel userProfileDataModel
   })async{
    try{
         _isLoading = true;
         notifyListeners();
       final responseData = await SupabaseManager.supabaseClient.from("user_profile").upsert({
         "name" : userProfileDataModel.name,
         "address" : userProfileDataModel.address,
         "license_number" : userProfileDataModel.licenseNumber,
         "dbs_certificate_number" : userProfileDataModel.dbsCertificateNumber,
         "driver_license_number" : userProfileDataModel.driverLicenseNumber,
         "utr_number" : userProfileDataModel.utrNumber,
         "user_id" : supabaseClient.auth.currentUser!.id,
         "latitude" : userProfileDataModel.latitude,
         "longitude" : userProfileDataModel.latitude,
         "is_registration_completed" : true,
         "is_supervisor" : userProfileDataModel.isSupervisor
       },onConflict: ("user_id")
       ).select().maybeSingle();
       if(responseData!=null && responseData.isNotEmpty){
         debugPrint("User data inserted successfully $responseData");
         if(responseData["is_supervisor"]==true){
           Utils.navigateToOffAll(AppRoutes.supervisorDashboardView);
         }else{
           Utils.navigateToOffAll(AppRoutes.workerDashboardView);
         }
       }else {
         debugPrint("User data insertion failed $responseData");
       }
    } on SocketException catch (e) {
      debugPrint("⚠️ No internet or host unreachable: ${e.message}");
      Utils.showToast(msg: "⚠️ No internet or host unreachable");
    }
    catch (ex){
      debugPrint("Exception occurred while inserting user profile data $ex");
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCurrentLocation()async{
   Position? position =  await GeolocatorServices.fetchCurrentLocation();
   if(position!=null){
     locationPosition = position;
   }
   debugPrint("Current location : ${position?.latitude} : ${position?.longitude}");
   notifyListeners();
  }

  Future<void> checkUserLoginStatus()async{
    try{
      final session = supabaseClient.auth.currentSession;
      final user = supabaseClient.auth.currentUser;
      final bool isSignedUp = LocalDatabase.sharePrefs!.getBool(LocalDbKeys.isSignedUp) ?? false;

      print("user signup status : $isSignedUp");
      if(session != null && user != null){
          await checkUserRegistrationStatus();
      }else if(isSignedUp){
        Utils.navigateToOffAll(AppRoutes.loginView);
      }else{
        Utils.navigateToOffAll(AppRoutes.onBoardingView);
      }
    }on SocketException catch (e) {
      debugPrint("⚠️ No internet or host unreachable: ${e.message}");
      Utils.showToast(msg: "⚠️ No internet or host unreachable");
    } catch (ex){
      debugPrint("Exception occurred while checking user existence $ex");
    }

  }

  Future<void> checkUserRegistrationStatus()async{
   try{
      final userStatusResponse = await SupabaseManager.supabaseClient.from("user_profile")
                                             .select()
                                             .eq("user_id",supabaseClient.auth.currentUser!.id)
                                             .maybeSingle();
      if(userStatusResponse!=null && userStatusResponse.isNotEmpty){
        if(userStatusResponse["is_registration_completed"] == true){
               if(userStatusResponse['is_supervisor'] == true){
                  Utils.navigateToOffAll(AppRoutes.supervisorDashboardView);
               }else{
                 Utils.navigateToOffAll(AppRoutes.workerDashboardView);
               }
        }else{
          Utils.navigateToOffAll(AppRoutes.registrationView);
        }
      }

   } on SocketException catch (e) {
     debugPrint("No internet or host unreachable: ${e.message}");
     Utils.showToast(msg: "No internet or host unreachable");
   } on AuthException catch (e) {
     debugPrint("❌ Auth error: ${e.message}");
     Utils.navigateToOffAll(AppRoutes.supervisorDashboardView);
     Utils.showToast(msg: "No internet or host unreachable");
   } catch (ex){
      debugPrint("Exception occurred while checking user registration $ex");
   }

  }

  /// validation methods
  String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^[6-9]\d{9}$'); // Indian 10-digit format
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Enter a valid 10-digit phone number';
    }

    return null;
  }
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  bool checkFieldEmptyOrNot(){
     if(fullNameController.text.trim().isEmpty || addressController.text.trim().isEmpty
         || licenseController.text.trim().isEmpty || dbsCertificateController.text.trim().isEmpty
         || driverLicenseController.text.trim().isEmpty || utrController.text.trim().isEmpty){
       return true;
     }else{
       return false;
     }
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    fullNameController.clear();
    phoneNumberController.clear();
    addressController.clear();
    licenseController.clear();
    dbsCertificateController.clear();
    driverLicenseController.clear();
    utrController.clear();
    accountNumberController.clear();
    sortCodeController.clear();
  }
}
