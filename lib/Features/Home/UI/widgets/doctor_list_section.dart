import 'package:flutter/material.dart';
import 'package:carepulse/Core/components/media_query.dart';
import 'package:carepulse/Features/Top-Doctors/Data/Model/doctor_model.dart';
import 'package:carepulse/Features/Top-Doctors/Data/sample_doctors_data.dart';

import 'doctor_card.dart';

class DoctorListSection extends StatelessWidget {
  const DoctorListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    // Using the first two doctors from sample data
    final List<DoctorModel> featuredDoctors = [
      sampleDoctors[0],
      sampleDoctors[1],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Doctors',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          ...featuredDoctors.map((doctor) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: DoctorCard(
                  doctor: doctor,
                  mq: mq,
                ),
              )),
        ],
      ),
    );
  }
}
