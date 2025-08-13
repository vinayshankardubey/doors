import 'dart:async';
import 'package:doors/core/constant/app_colors.dart';
import 'package:doors/core/constant/app_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/providers/auth_provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late AuthProvider authProvider;
  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _navigateToHome(authProvider: authProvider);
    });
  }

  void _navigateToHome({required AuthProvider authProvider}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
       await authProvider.checkUserLoginStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Center(
        child: Image.asset(AppImages.splashImg),
    ));
  }
}
