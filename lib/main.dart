import 'package:careplus/Core/Routing/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Core/DI/dependency_injection.dart';
import 'Core/Routing/app_router.dart';
import 'Features/Auth/logic/auth_cubit.dart';
import 'Features/Top-Doctors/Logic/doctor_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setUpGetIt();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return  MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => getIt<AuthCubit>(),
            ),
            // Provide DoctorCubit at app level to ensure data preloading
            BlocProvider(
              create: (context) => getIt<DoctorCubit>(),
            ),
          ],
          child: MaterialApp(
            title: 'Care Plus',
            debugShowCheckedModeBanner: false,
            navigatorKey: MyApp.navigatorKey,
            initialRoute: Routes.splashScreen,
            onGenerateRoute: appRouter.generateRoute,
          ),
        );
      },
    );
  }
}
