import 'package:doors/modules/security_worker/dashboard/presenter/views/worker_dashboard_view.dart';
import 'package:doors/modules/security_worker/home/presenter/views/job_details_view.dart';
import 'package:doors/modules/security_worker/home/presenter/views/worker_home_view.dart';
import 'package:doors/modules/supervisor/dashboard/presenter/views/supervisor_dashboard_view.dart';
import 'package:doors/modules/supervisor/home/presenter/views/job_post_view.dart';
import 'package:doors/modules/supervisor/home/presenter/views/supervisor_home_view.dart';
import 'package:doors/modules/supervisor/profile/presenter/views/supervisor_profile_view.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../../modules/common/authentication/presenter/views/login_view.dart';
import '../../modules/common/authentication/presenter/views/onboarding_view.dart';
import '../../modules/common/authentication/presenter/views/registration_view.dart';
import '../../modules/common/authentication/presenter/views/sign_up_view.dart';
import '../../modules/common/authentication/presenter/views/splash_view.dart';
import '../../modules/security_worker/home/infra/models/job_model.dart';
import '../../modules/security_worker/myJobs/presenter/views/worker_my_job_view.dart';
import '../../modules/security_worker/profile/presenter/views/worker_profile_view.dart';
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

    /// Common Routes
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
      path: AppRoutes.registrationView,
      builder: (context, state) => RegistrationView(),
    ),


    /// Worker Specific Routes
    GoRoute(
      path: AppRoutes.workerHomeView,
      builder: (context, state) => WorkerHomeView(),
    ),
    GoRoute(
      path: AppRoutes.workerDashboardView,
      builder: (context, state) => WorkerDashboardView(),
    ),
    GoRoute(
      path: AppRoutes.workerProfileView,
      builder: (context, state) => WorkerProfileView(),
    ),



    /// Supervisor/Admin Specific Routes
    GoRoute(
        path: AppRoutes.supervisorHomeView,
        builder: (context,state)=> SupervisorHomeView()
    ),

    GoRoute(
        path: AppRoutes.supervisorProfileView,
        builder: (context,state)=> SupervisorProfileView()
    ),

    GoRoute(
        path: AppRoutes.supervisorDashboardView,
        builder: (context,state)=> SupervisorDashboardView()
    ),
    GoRoute(
        path: AppRoutes.jobPostView,
        builder: (context,state)=> JobPostView()
    ),
    GoRoute(
        path: AppRoutes.workerMyJobView,
        builder: (context,state)=> WorkerMyJobView()
    ),
    GoRoute(
        path: AppRoutes.jobDetailsPage,
        builder: (context,state){
         final jobData = state.extra as JobModel?;
          return JobDetailsPage(job: jobData!);
        }
    )


  ],
);

