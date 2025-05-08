import 'package:carepulse/Core/styles/image_manager.dart';
import 'package:flutter/material.dart';

import 'category_card.dart';

class CategoriesSection extends StatelessWidget {
  final void Function(String?)? onCategorySelected;
  final String? selectedCategory;
  const CategoriesSection(
      {super.key, this.onCategorySelected, this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryCard('Top doctor', ImageManager.topDoctorIcon),
              _buildCategoryCard('Cardiology', ImageManager.cardiologyIcon),
              _buildCategoryCard('Medicine', ImageManager.medicineIcon),
              _buildCategoryCard('General', ImageManager.generalIcon),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String label, String icon) {
    final isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () {
        if (onCategorySelected != null) {
          onCategorySelected!(isSelected ? null : label);
        }
      },
      child: CategoryCard(
        icon: icon,
        label: label,
        color: isSelected ? const Color(0xFF9370DB) : null,
      ),
    );
  }
}
