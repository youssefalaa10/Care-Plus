import 'package:carepulse/Core/Routing/routes.dart';
import 'package:carepulse/Core/styles/color_manager.dart';
import 'package:carepulse/Features/Auth/logic/auth_cubit.dart';
import 'package:carepulse/Features/Doctor-Details/UI/doctor_details_screen.dart';
import 'package:carepulse/Features/Top-Doctors/UI/top_doctors_screen.dart';
import 'package:carepulse/Features/Top-Doctors/Data/Model/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/DI/dependency_injection.dart';
import '../../../Core/components/media_query.dart';
import '../../../Core/styles/image_manager.dart';
import '../../Top-Doctors/Logic/doctor_cubit.dart';
import 'widgets/categories_section.dart';
import 'widgets/welcome_section.dart';

class DoctorFinderScreen extends StatefulWidget {
  const DoctorFinderScreen({super.key});

  @override
  State<DoctorFinderScreen> createState() => _DoctorFinderScreenState();
}

class _DoctorFinderScreenState extends State<DoctorFinderScreen> {
  // Will fetch doctors from Firestore
  late List<DoctorModel> doctorsList = [];

  @override
  void initState() {
    super.initState();
    // Load doctors when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorCubit>().loadTopRatedDoctors(limit: 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeSection(),
              const CategoriesSection(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
                child: BlocBuilder<DoctorCubit, DoctorState>(
                  builder: (context, state) {
                    if (state is DoctorLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DoctorsLoaded) {
                      final doctors = state.doctors;
                      if (doctors.isEmpty) {
                        return const Center(child: Text('No doctors found'));
                      }
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: doctors.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => getIt<DoctorCubit>(),
                                  child: DoctorDetailsScreen(
                                    doctor: doctors[index],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: DoctorCard(
                            doctor: doctors[index],
                            mq: mq,
                          ),
                        ),
                      );
                    } else if (state is DoctorError) {
                      // Show error message
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Error: ${state.message}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<DoctorCubit>()
                                    .loadTopRatedDoctors(limit: 5);
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // If no state is available yet, show loading
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              SizedBox(height: mq.height(2)),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: mq.height(2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Settings Icon with Dropdown
          PopupMenuButton<String>(
            icon: Container(
              padding: EdgeInsets.all(mq.width(1)),
              decoration: BoxDecoration(
                color: ColorManager.primaryColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.settings,
                size: mq.width(6),
                color: Colors.white,
              ),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                // Handle logout action
                _handleLogout(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red[400]),
                    SizedBox(width: mq.width(2)),
                    const Text('Logout'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.grey[700]),
                    SizedBox(width: mq.width(2)),
                    const Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: mq.width(5),
            backgroundImage: AssetImage(ImageManager.doctor1),
            backgroundColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement actual logout logic
                context.read<AuthCubit>().signOut();

                // Close dialog
                Navigator.of(context).pop();

                // Display logout message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );

                // Navigate to login screen
                Navigator.pushReplacementNamed(context, Routes.loginScreen);
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
