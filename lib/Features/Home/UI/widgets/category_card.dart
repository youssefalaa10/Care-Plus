import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String icon;
  final String label;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.label, Color? color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60, // Reduced from 75
          height: 60, // Reduced from 75
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12), // Slightly reduced radius
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Center( // Added Center widget
            child: Image.asset(
              icon,
              width: 40, // Adjusted from 15
              height: 40, // Adjusted from 10
              fit: BoxFit.contain, // Added fit property
            ),
          ),
        ),
        const SizedBox(height: 6), // Reduced from 8
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}