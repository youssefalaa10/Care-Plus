import 'package:carepulse/Core/styles/image_manager.dart';
import 'package:flutter/material.dart';

import 'category_card.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CategoryCard(
                icon: ImageManager.topDoctorIcon,
                label: 'Top doctor',
                // color: Colors.green,
              ),
              CategoryCard(
                icon: ImageManager.cardiologyIcon,
                label: 'Cardiology',
                // color: Colors.red,
              ),
              CategoryCard(
                icon: ImageManager.medicineIcon,
                label: 'Medicine',
                // color: Color(0xFF9370DB),
              ),
              CategoryCard(
                icon: ImageManager.generalIcon,
                label: 'General',
                // color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
