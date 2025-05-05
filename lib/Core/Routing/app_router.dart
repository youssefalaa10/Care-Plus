import 'package:carepulse/Core/Routing/routes.dart';
import 'package:carepulse/Features/Auth/login/UI/login_screen.dart';
import 'package:carepulse/Features/Home/UI/home_screen.dart';
import 'package:flutter/material.dart';

import '../../Features/Auth/register/register_screen.dart';
import '../../Features/Doctor-Details/UI/doctor_details_screen.dart';
import '../../Features/Layout/UI/layout_screen.dart';
import '../../Features/Request_Doctor/UI/request_doctor_screen.dart';
import '../../Features/Schedule/schedule_screen.dart';
import '../../Features/Top-Doctors/UI/top_doctors_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // login screen
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      // register screen
      case Routes.registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      // main layout
      case Routes.mainLayout:
        return MaterialPageRoute(builder: (_) => const MainLayout());

      // home screen
      case Routes.doctorFinderScreen:
        return MaterialPageRoute(builder: (_) => DoctorFinderScreen());

      // top doctors screen
      case Routes.topDoctorsScreen:
        return MaterialPageRoute(builder: (_) => const TopDoctors());

      // doctor details screen
      case Routes.doctorDetailsScreen:
        return MaterialPageRoute(builder: (_) => const DoctorDetailsScreen());

      // schedule screen
      case Routes.scheduleScreen:
        return MaterialPageRoute(builder: (_) => const ScheduleScreen());

      // request doctor screen
      case Routes.requestDoctorScreen:
        return MaterialPageRoute(builder: (_) => const RequestDoctorScreen());
    }
    return null;
  }
}
