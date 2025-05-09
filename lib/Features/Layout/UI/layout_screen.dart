import 'package:careplus/Core/DI/dependency_injection.dart';
import 'package:careplus/Core/styles/image_manager.dart';
import 'package:careplus/Features/Auth/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Routing/routes.dart';
import '../../../Core/styles/color_manager.dart';
import '../../../Core/styles/icon_broken.dart';
import '../../Home/UI/home_screen.dart';
import '../../Profile/UI/profile_screen.dart';
import '../../Schedule/schedule_screen.dart';
import '../../Top-Doctors/Logic/doctor_cubit.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // Screen widgets
  final List<Widget> _screens = [
    DoctorFinderScreen(),
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<DoctorCubit>()),
        BlocProvider(create: (context) => getIt<AuthCubit>()),
      ],
      child: ScheduleScreen(),
    ),
    BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SafeArea(
            bottom: false,
            child: _screens[_currentIndex],
          ),

          // Floating Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(IconBroken.home, 0),
                  _buildNavItem(IconBroken.calendar, 1),
                  _buildNavItem(IconBroken.profile, 2),
                  _buildAddButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: isSelected ? ColorManager.primaryColor : Colors.grey,
                size: 28,
              ),
              if (isSelected)
                Positioned(
                  bottom: -8,
                  child: Image.asset(
                    ImageManager.dotIcon,
                    height: 8,
                    width: 8,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildNavItemWithBadge(IconData icon, int index, String badgeText) {
  //   final isSelected = _currentIndex == index;
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         _currentIndex = index;
  //       });
  //     },
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Stack(
  //           alignment: Alignment.center,
  //           clipBehavior: Clip.none,
  //           children: [
  //             Icon(
  //               icon,
  //               color: isSelected ? ColorManager.primaryColor : Colors.grey,
  //               size: 28,
  //             ),
  //             Positioned(
  //               top: -6,
  //               right: -6,
  //               child: CircleAvatar(
  //                 radius: 8,
  //                 backgroundColor: ColorManager.primaryColor,
  //                 child: Text(
  //                   badgeText,
  //                   style: const TextStyle(fontSize: 10, color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //             if (isSelected)
  //               Positioned(
  //                 bottom: -8,
  //                 child: Image.asset(
  //                   ImageManager.dotIcon,
  //                   height: 8,
  //                   width: 8,
  //                 ),
  //               ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.requestDoctorScreen);
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: ColorManager.primaryColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400]!,
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: const Icon(Icons.add,
                color: ColorManager.primaryColor, size: 28),
          ),
        ),
      ),
    );
  }
}
