import 'package:careplus/Core/Routing/routes.dart';
import 'package:careplus/Core/styles/color_manager.dart';
import 'package:careplus/Core/styles/icon_broken.dart';
import 'package:careplus/Features/Auth/logic/auth_cubit.dart';
import 'package:careplus/Features/Top-Doctors/UI/top_doctors_screen.dart';
import 'package:careplus/Features/Top-Doctors/Data/Model/doctor_model.dart';
import 'package:careplus/Features/not_found/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late List<DoctorModel> doctorsList = [];
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();

    context.read<DoctorCubit>().loadTopRatedDoctors();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
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
              WelcomeSection(onSearchChanged: _onSearchChanged),
              CategoriesSection(
                  onCategorySelected: _onCategorySelected,
                  selectedCategory: _selectedCategory),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
                child: BlocBuilder<DoctorCubit, DoctorState>(
                  builder: (context, state) {
                    if (state is DoctorLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DoctorsLoaded) {
                      var doctors = state.doctors;
                      if (_searchQuery.isNotEmpty) {
                        doctors = doctors
                            .where((d) => d.name
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()))
                            .toList();
                      }
                      if (_selectedCategory != null &&
                          _selectedCategory!.isNotEmpty) {
                        doctors = doctors
                            .where((d) => d.speciality
                                .toLowerCase()
                                .contains(_selectedCategory!.toLowerCase()))
                            .toList();
                      }
                      if (doctors.isEmpty) {
                        return NotFoundScreen(
                          title: 'No doctors found',
                        );
                      }
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: doctors.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.doctorDetailsScreen,
                              arguments: doctors[index],
                            );
                          },
                          child: DoctorCard(
                            doctor: doctors[index],
                            mq: mq,
                          ),
                        ),
                      );
                    } else if (state is DoctorError) {
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
                                    .loadTopRatedDoctors();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else {
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
          PopupMenuButton<String>(
            icon: Container(
              padding: EdgeInsets.all(mq.width(1)),
              decoration: BoxDecoration(
                color: ColorManager.primaryColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                IconBroken.user,
                size: mq.width(6),
                color: Colors.white,
              ),
            ),
            onSelected: (value) {
              if (value == 'logout') {
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
                value: 'profile',
                child: Row(
                  children: [
                    Icon(IconBroken.user, color: Colors.grey[700]),
                    SizedBox(width: mq.width(2)),
                    const Text('Profile'),
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
                context.read<AuthCubit>().signOut();

                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );

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
