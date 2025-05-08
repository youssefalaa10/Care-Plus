import 'package:carepulse/Core/DI/dependency_injection.dart';
import 'package:carepulse/Core/Routing/routes.dart';
import 'package:carepulse/Features/Auth/UI/login/UI/login_screen.dart';
import 'package:carepulse/Features/Auth/logic/auth_cubit.dart';
import 'package:carepulse/Features/Home/UI/home_screen.dart';
import 'package:carepulse/Features/Top-Doctors/Data/Model/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Features/Auth/UI/register/UI/register_screen.dart';
import '../../Features/Doctor-Details/UI/doctor_details_screen.dart';
import '../../Features/Layout/UI/layout_screen.dart';
import '../../Features/Request_Doctor/UI/request_doctor_screen.dart';
import '../../Features/Schedule/schedule_screen.dart';
import '../../Features/Top-Doctors/Logic/doctor_cubit.dart';
import '../../Features/Top-Doctors/UI/top_doctors_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // login screen
      case Routes.loginScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<AuthCubit>(),
                  child: const LoginScreen(),
                ));

      // register screen
      case Routes.registerScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<AuthCubit>(),
                  child: const RegisterScreen(),
                ));

      // main layout
      case Routes.mainLayout:
        return MaterialPageRoute(builder: (_) => const MainLayout());

      // home screen
      case Routes.doctorFinderScreen:
        return MaterialPageRoute(builder: (_) => DoctorFinderScreen());

      // top doctors screen
      case Routes.topDoctorsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<DoctorCubit>(),
            child: const TopDoctors(),
          ),
        );

      // doctor details screen
      case Routes.doctorDetailsScreen:
        final doctor = settings.arguments as DoctorModel;
        return MaterialPageRoute(
            builder: (_) => DoctorDetailsScreen(doctor: doctor));

      // schedule screen
      case Routes.scheduleScreen:
        return MaterialPageRoute(builder: (_) => const ScheduleScreen());

      // request doctor screen
      case Routes.requestDoctorScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<DoctorCubit>(),
                  child: const RequestDoctorScreen(),
                ));
    }
    return null;
  }
}
