import 'package:doors/modules/supervisor/home/presenter/controllers/provider/supervisor_home_provider.dart';
import 'package:doors/supabase/supabase_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/database/local_database.dart';
import 'core/routes/app_router.dart';
import 'modules/common/authentication/presenter/controllers/providers/auth_provider.dart';
import 'modules/security_worker/home/presenter/controllers/provider/worker_home_provider.dart';
import 'modules/security_worker/myJobs/presenter/controllers/provider/worker_my_job_provider.dart';
import 'modules/supervisor/profile/presenter/controllers/profile_provider.dart';

void main({String env = 'dev'}) async{
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseManager.initialize(env);
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]
  );
  await LocalDatabase().initSharedPref();
  runApp(MyApp(env: env));
}

class MyApp extends StatelessWidget {
  final String env;

  const MyApp({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
      builder: (context,child) {
        return MultiProvider(
            providers: [
            /// common
            ChangeNotifierProvider(create: (context) => AuthProvider()),
            ChangeNotifierProvider(create: (context) => ProfileProvider()),

            /// Worker Specific

            ChangeNotifierProvider(create: (context) => WorkerHomeProvider()),
            ChangeNotifierProvider(create: (context) => WorkerMyJobProvider()),

            /// Supervisor Specific
            ChangeNotifierProvider(create: (context) => SupervisorHomeProvider()),
            ],
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: "Doors",
              routerConfig: appRouter,
              )
             );
           }
      );
  }
}
