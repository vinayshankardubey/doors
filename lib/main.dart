import 'package:doors/supabase/supabase_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/database/local_database.dart';
import 'core/routes/app_router.dart';
import 'modules/authentication/presenter/controllers/providers/auth_provider.dart';

void main({String env = 'dev'}) async{
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseManager.initialize(env);
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
            ChangeNotifierProvider(create: (context) => AuthProvider()),
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
