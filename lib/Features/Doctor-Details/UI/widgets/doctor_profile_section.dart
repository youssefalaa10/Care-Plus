import 'package:carepulse/Core/styles/image_manager.dart';
import 'package:flutter/material.dart';

import '../../../../Core/components/media_query.dart';
import '../../../../Features/Top-Doctors/Data/Model/doctor_model.dart';

class DoctorProfileSection extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorProfileSection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(16), // Set the corner radius to 8
                child: Container(
                  width: mq.width(30), // Adjusted size for clarity
                  height: mq.width(30),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Fallback background color
                    image: DecorationImage(
                      image: NetworkImage(doctor.imageUrl),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) =>
                          const AssetImage(ImageManager.doctor1),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: mq.width(4),
                  height: mq.width(4),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: mq.height(2)),
          Text(
            doctor.name ?? 'Doctor Name',
            style: TextStyle(
              fontSize: mq.width(5),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: mq.height(1)),
          Text(
            'Cardio Specialist',
            style: TextStyle(
              fontSize: mq.width(4),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
