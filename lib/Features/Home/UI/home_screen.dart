import 'package:carepulse/Features/Top-Doctors/UI/top_doctors_screen.dart';
import 'package:flutter/material.dart';

import '../../../Core/components/media_query.dart';
import '../../../Core/components/styles/image_manager.dart';
import 'widgets/categories_section.dart';
import 'widgets/welcome_section.dart';
class DoctorFinderScreen extends StatelessWidget {
  DoctorFinderScreen({super.key});

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
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(), 
                  shrinkWrap: true, 
                  itemCount: doctorsList.length,
                  itemBuilder: (context, index) => DoctorCard(
                    doctor: doctorsList[index],
                    mq: mq,
                  ),
                ),
              ),
              SizedBox(height: mq.height(2)), 
            ],
          ),
        ),
      ),
    );
  }

  // Sample data
  final List<Doctor> doctorsList = [
    Doctor(
      name: 'Dr. Rodger Struck',
      speciality: 'Heart Surgeon, London, England',
      imageUrl:
          ImageManager.doctor1,
      rating: 4.8,
      isOnline: true,
    ),
    Doctor(
      name: 'Dr. Kathy Pacheco',
      speciality: 'Heart Surgeon, London, England',
      imageUrl:
          ImageManager.doctor1,
      rating: 4.8,
    ),
    Doctor(
      name: 'Dr. Lorri Warf',
      speciality: 'General Dentist',
      imageUrl:
           ImageManager.doctor1,
      rating: 4.8,
      isOnline: true,
    ),
    Doctor(
      name: 'Dr. Chris Glasser',
      speciality: 'Heart Surgeon, London, England',
      imageUrl:
         ImageManager.doctor1,
      rating: 4.8,
    ),
  ];
}
