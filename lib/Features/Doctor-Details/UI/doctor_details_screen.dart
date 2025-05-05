import 'package:flutter/material.dart';

import '../../../Core/components/media_query.dart';
import '../../../Features/Top-Doctors/UI/top_doctors_screen.dart';
import 'widgets/doctor_profile_section.dart';
import 'widgets/doctor_stats_section.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor? doctor;

  const DoctorDetailsScreen({super.key, this.doctor});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Appointment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoctorProfileSection(doctor: doctor),
              SizedBox(height: mq.height(3)),
              const DoctorStatsSection(),
              SizedBox(height: mq.height(3)),
              AboutDoctorSection(doctor: doctor),
              SizedBox(height: mq.height(3)),
              const ScheduleSection(),
              SizedBox(height: mq.height(3)),
              const VisitHourSection(),
              SizedBox(height: mq.height(4)),
              const BookingButton(),
              SizedBox(height: mq.height(4)),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutDoctorSection extends StatelessWidget {
  final Doctor? doctor;

  const AboutDoctorSection({super.key, this.doctor});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Doctor',
          style: TextStyle(
            fontSize: mq.width(4.5),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: mq.height(1)),
        Text(
          '${doctor?.name ?? "Doctor"} is a ${doctor?.speciality ?? "specialist"} with excellent ratings. Available for private consultation.',
          style: TextStyle(
            fontSize: mq.width(3.8),
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class ScheduleSection extends StatefulWidget {
  const ScheduleSection({super.key});

  @override
  State<ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends State<ScheduleSection> {
  int selectedIndex = 1; // Default selected index

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Schedules',
              style: TextStyle(
                fontSize: mq.width(4.5),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Here you would typically handle the booking logic
                // For now, just navigate back to the home screen
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Text(
                    'August',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: mq.width(3.8),
                    ),
                  ),
                  Icon(Icons.chevron_right, size: mq.width(5)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: mq.height(2)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            5,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: _buildDateCard(
                context,
                (index + 6).toString(),
                ['Sun', 'Mon', 'Tue', 'Wen', 'Tur'][index],
                index == selectedIndex,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard(
      BuildContext context, String date, String day, bool isSelected) {
    final mq = CustomMQ(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: mq.width(4),
        vertical: mq.height(1),
      ),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFB28CFF) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? const Color(0xFFB28CFF) : Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: mq.width(4),
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: mq.height(0.5)),
          Text(
            day,
            style: TextStyle(
              fontSize: mq.width(3.5),
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class VisitHourSection extends StatefulWidget {
  const VisitHourSection({super.key});

  @override
  State<VisitHourSection> createState() => _VisitHourSectionState();
}

class _VisitHourSectionState extends State<VisitHourSection> {
  int selectedIndex = 1; // Default selected index
  final hours = [
    '11:00AM',
    '12:00AM',
    '01:00AM',
    '02:00AM',
    '03:00AM',
    '04:00AM',
    '05:00AM',
    '06:00AM'
  ];

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visit Hour',
          style: TextStyle(
            fontSize: mq.width(4.5),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: mq.height(2)),
        Wrap(
          spacing: mq.width(3),
          runSpacing: mq.height(2),
          children: List.generate(
            hours.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: _buildTimeChip(
                context,
                hours[index],
                index == selectedIndex,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeChip(BuildContext context, String time, bool isSelected) {
    final mq = CustomMQ(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: mq.width(4),
        vertical: mq.height(1),
      ),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFB28CFF) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? const Color(0xFFB28CFF) : Colors.grey.shade300,
        ),
      ),
      child: Text(
        time,
        style: TextStyle(
          fontSize: mq.width(3.5),
          color: isSelected ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }
}

class BookingButton extends StatelessWidget {
  const BookingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Here you would typically handle the booking logic
          // For now, just navigate back to the home screen
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB28CFF),
          padding: EdgeInsets.symmetric(vertical: mq.height(2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          'Book Appointment',
          style: TextStyle(
            color: Colors.white,
            fontSize: mq.width(4),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
