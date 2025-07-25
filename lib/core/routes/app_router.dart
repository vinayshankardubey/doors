import 'package:doors/modules/authentication/presenter/views/login_view.dart';
import 'package:doors/modules/authentication/presenter/views/onboarding_view.dart';
import 'package:doors/modules/authentication/presenter/views/sign_up_view.dart';
import 'package:doors/modules/home/presenter/views/home_view.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../../modules/authentication/presenter/views/splash_view.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splashView,
  redirect: (context, state) {
    final uriString = state.uri.toString();
    Uri? uri;
    try {
      uri = Uri.parse(uriString);
      if (uri.scheme != 'http' && uri.scheme != 'https') {
        debugPrint('🔒 Ignoring non-web scheme: ${uri.scheme}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Failed to parse URI: $uriString');
      return null;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splashView,
      builder: (context, state) => SplashView(),
    ),
    GoRoute(
      path: AppRoutes.loginView,
      builder: (context, state) => LoginView(),
    ),
    GoRoute(
      path: AppRoutes.signUpView,
      builder: (context, state) => SignUpView(),
    ),
    GoRoute(
      path: AppRoutes.onBoardingView,
      builder: (context, state) => OnboardingView(),
    ),

    GoRoute(
      path: AppRoutes.homeView,
      builder: (context, state) => HomeView(),
    ),
  ],
);

