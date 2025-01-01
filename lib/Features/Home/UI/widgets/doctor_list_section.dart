import 'package:flutter/material.dart';

import 'doctor_card.dart';

class DoctorListSection extends StatelessWidget {
  const DoctorListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          DoctorCard(
            name: 'Dr. Maria Waston',
            specialty: 'Heart Surgeon, London, England',
            rating: '4.8',
            isOnline: true,
          ),
          SizedBox(height: 15),
          DoctorCard(
            name: 'Dr. Stevi Jessi',
            specialty: 'General Dentist',
            rating: '4.7',
            isOnline: true,
          ),
        ],
      ),
    );
  }
}
