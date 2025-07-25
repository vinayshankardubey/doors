import 'dart:core';
import 'package:doors/core/constant/app_strings.dart';
import 'package:doors/core/routes/app_routes.dart';
import 'package:doors/core/utils.dart';
import 'package:doors/supabase/supabase_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/constant/app_images.dart';

class AuthProvider extends ChangeNotifier{
  final PageController pageController = PageController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final supabaseClient = SupabaseManager.supabaseClient;
  bool obscure = true;
  bool _isLoading = false;
  int currentPage = 0;

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
        Utils.navigateToOffAll(AppRoutes.homeView);
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

  Future<void> checkUserLoginStatus()async{
    try{
        final session = supabaseClient.auth.currentSession;
        final user = supabaseClient.auth.currentUser;
        if(session != null && user != null){
          Utils.navigateToOffAll(AppRoutes.homeView);
        }else{
          Utils.navigateToOffAll(AppRoutes.loginView);
        }
    }catch (ex){
      debugPrint("Exception occurred while checking user existence $ex");
    }
    
  }
  
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

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    fullNameController.clear();
    phoneNumberController.clear();
  }
}
