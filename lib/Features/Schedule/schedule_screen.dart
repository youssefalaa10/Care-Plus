import 'package:flutter/material.dart';
import '../../Core/components/media_query.dart';
import '../../Core/components/custom_button.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Upcoming', 'Completed', 'Canceled'];

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: const Text(
          'Schedule',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabBar(mq),
            SizedBox(height: mq.height(3)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Nearest visit', mq),
                    SizedBox(height: mq.height(1.5)),
                    _buildAppointmentCard(
                      doctorName: 'Dr. Chris Frazier',
                      specialty: 'Pediatrician',
                      date: '12/03/2021',
                      time: '10:30 AM',
                      isConfirmed: true,
                      avatarColor: const Color(0xFFFEE2E7),
                      avatarAsset: 'assets/images/doctor1.png',
                      mq: mq,
                    ),
                    SizedBox(height: mq.height(3)),
                    _buildSectionTitle('Future visits', mq),
                    SizedBox(height: mq.height(1.5)),
                    _buildAppointmentCard(
                      doctorName: 'Dr. Charlie Black',
                      specialty: 'Cardiologist',
                      date: '12/03/2021',
                      time: '10:30 AM',
                      isConfirmed: true,
                      avatarColor: const Color(0xFFE2F4FF),
                      avatarAsset: 'assets/images/doctor1.png',
                      mq: mq,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(CustomMQ mq) {
    return Container(
      height: mq.height(6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(mq.width(4)),
      ),
      child: Row(
        children: List.generate(
          _tabs.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTabIndex == index
                      ? const Color(0xFFB28CFF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(mq.width(4)),
                ),
                alignment: Alignment.center,
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    color:
                        _selectedTabIndex == index ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: mq.width(3.5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, CustomMQ mq) {
    return Text(
      title,
      style: TextStyle(
        fontSize: mq.width(4.5),
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildAppointmentCard({
    required String doctorName,
    required String specialty,
    required String date,
    required String time,
    required bool isConfirmed,
    required Color avatarColor,
    required String avatarAsset,
    required CustomMQ mq,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(mq.width(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(mq.width(4)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: mq.width(12),
                height: mq.width(12),
                decoration: BoxDecoration(
                  color: avatarColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    avatarAsset,
                    width: mq.width(8),
                    height: mq.width(8),
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: mq.width(6),
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: mq.width(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: TextStyle(
                        fontSize: mq.width(4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: mq.height(0.5)),
                    Text(
                      specialty,
                      style: TextStyle(
                        fontSize: mq.width(3.5),
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: mq.height(2)),
          Row(
            children: [
              _buildInfoItem(
                icon: Icons.calendar_today,
                text: date,
                mq: mq,
              ),
              SizedBox(width: mq.width(5)),
              _buildInfoItem(
                icon: Icons.access_time,
                text: time,
                mq: mq,
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: mq.width(2),
                  vertical: mq.height(0.5),
                ),
                decoration: BoxDecoration(
                  color: isConfirmed
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(mq.width(1)),
                ),
                child: Row(
                  children: [
                    Icon(
                      isConfirmed ? Icons.check_circle : Icons.pending,
                      color: isConfirmed ? Colors.green : Colors.orange,
                      size: mq.width(3),
                    ),
                    SizedBox(width: mq.width(1)),
                    Text(
                      isConfirmed ? 'Confirmed' : 'Pending',
                      style: TextStyle(
                        fontSize: mq.width(3),
                        color: isConfirmed ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: mq.height(2)),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Cancel',
                  onPressed: () {},
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  borderRadius: mq.width(2),
                  verticalPadding: mq.height(1.5),
                  fontSize: mq.width(3.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: mq.width(3)),
              Expanded(
                child: CustomButton(
                  text: 'Confirm',
                  onPressed: () {},
                  backgroundColor: const Color(0xFFB28CFF),
                  borderRadius: mq.width(2),
                  verticalPadding: mq.height(1.5),
                  fontSize: mq.width(3.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String text,
    required CustomMQ mq,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: mq.width(3.5),
          color: Colors.grey,
        ),
        SizedBox(width: mq.width(1)),
        Text(
          text,
          style: TextStyle(
            fontSize: mq.width(3.5),
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
