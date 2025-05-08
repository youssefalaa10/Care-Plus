import 'package:flutter/material.dart';

import '../../../../Core/components/media_query.dart';

class DoctorStatsSection extends StatelessWidget {
  const DoctorStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      color: const Color(0xFFB28CFF), 
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatCard(context, '350+', 'Patients', const Color(0xFF9C89FF)),
          _buildStatCard(context, '15+', 'Exp. years', const Color(0xFF70D99C)),
          _buildStatCard(context, '284+', 'Reviews', const Color(0xFFFF8080)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String value, String label, Color valueColor) {
    final mq = CustomMQ(context);
    return Container(
      width: mq.width(25),
      padding: EdgeInsets.symmetric(
        vertical: mq.height(2),
        horizontal: mq.width(3),
      ),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: mq.width(6),
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          SizedBox(height: mq.height(0.5)),
          Text(
            label,
            style: TextStyle(
              fontSize: mq.width(3.5),
              fontWeight: FontWeight.w500,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
