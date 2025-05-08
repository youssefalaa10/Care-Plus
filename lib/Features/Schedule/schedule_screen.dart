import 'package:carepulse/Core/Routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Core/components/media_query.dart';
import '../../Core/components/custom_button.dart';
import '../Top-Doctors/Data/Repo/doctor_repo.dart';
import '../Top-Doctors/Data/Model/doctor_model.dart';
import '../Auth/logic/auth_cubit.dart';
import '../Auth/logic/auth_state.dart';

// Extension to capitalize first letter of a string
extension StringExtension on String {
  String capitalize() {
    return isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  }
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Upcoming', 'Completed', 'Canceled'];
  List<Appointment> _appointments = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  void _fetchAppointments() async {
    final authState = context.read<AuthCubit>().state;
    if (authState.status == AuthStatus.authenticated &&
        authState.user != null) {
      final userId = authState.user!.uid;
      DoctorRepo().getUserAppointments(userId).listen((appointments) {
        setState(() {
          _appointments =
              appointments; // No need to cast, using the correct type now
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Appointment> get _upcomingAppointments => _appointments
      .where((a) =>
          a.status == 'scheduled' ||
          a.status == 'pending' ||
          a.status == 'confirmed')
      .toList();
  List<Appointment> get _completedAppointments =>
      _appointments.where((a) => a.status == 'completed').toList();
  List<Appointment> get _canceledAppointments => _appointments
      .where((a) => a.status == 'cancelled' || a.status == 'canceled')
      .toList();
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildAppointmentsList(mq),
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

  Widget _buildAppointmentsList(CustomMQ mq) {
    List<Appointment> list;
    if (_selectedTabIndex == 0) {
      list = _upcomingAppointments;
    } else if (_selectedTabIndex == 1) {
      list = _completedAppointments;
    } else {
      list = _canceledAppointments;
    }

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today,
                size: mq.width(15), color: Colors.grey[300]),
            SizedBox(height: mq.height(2)),
            Text(
              'No appointments',
              style: TextStyle(
                fontSize: mq.width(4),
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: mq.height(4)),
            SizedBox(
              width: mq.width(60),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.requestDoctorScreen);
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
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (list.isNotEmpty && _selectedTabIndex == 0)
            _buildSectionTitle('Upcoming appointments', mq),
          if (list.isNotEmpty && _selectedTabIndex == 1)
            _buildSectionTitle('Completed appointments', mq),
          if (list.isNotEmpty && _selectedTabIndex == 2)
            _buildSectionTitle('Canceled appointments', mq),
          SizedBox(height: mq.height(1.5)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final appt = list[index];
              return _buildAppointmentCardFromModel(appt, mq);
            },
          ),
          SizedBox(height: mq.height(3)),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.requestDoctorScreen);
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCardFromModel(Appointment appt, CustomMQ mq) {
    final bool isConfirmed =
        appt.status == 'confirmed' || appt.status == 'completed';
    final bool isPending =
        appt.status == 'scheduled' || appt.status == 'pending';
    final bool isCanceled =
        appt.status == 'cancelled' || appt.status == 'canceled';

    Color statusColor = Colors.orange;
    if (isConfirmed) statusColor = Colors.green;
    if (isCanceled) statusColor = Colors.red;

    return Container(
      margin: EdgeInsets.only(bottom: mq.height(2)),
      padding: EdgeInsets.all(mq.width(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(mq.width(4)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
                  color: const Color(0xFFE2F4FF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: mq.width(6),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: mq.width(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Doctor ID: ${appt.doctorId}', // TODO: Replace with doctor name lookup
                      style: TextStyle(
                        fontSize: mq.width(4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: mq.height(0.5)),
                    Text(
                      'Appointment ID: ${appt.id.substring(0, 8)}...',
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
                text: appt.day,
                mq: mq,
              ),
              SizedBox(width: mq.width(5)),
              _buildInfoItem(
                icon: Icons.access_time,
                text: '${appt.timeSlot.startTime} - ${appt.timeSlot.endTime}',
                mq: mq,
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: mq.width(2),
                  vertical: mq.height(0.5),
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(mq.width(1)),
                ),
                child: Row(
                  children: [
                    Icon(
                      isConfirmed
                          ? Icons.check_circle
                          : (isCanceled ? Icons.cancel : Icons.pending),
                      color: statusColor,
                      size: mq.width(3),
                    ),
                    SizedBox(width: mq.width(1)),
                    Text(
                      appt.status.capitalize(),
                      style: TextStyle(
                        fontSize: mq.width(3),
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isCanceled && appt.status != 'completed')
            Padding(
              padding: EdgeInsets.only(top: mq.height(2)),
              child: Row(
                children: [
                  if (!isConfirmed)
                    Expanded(
                      child: CustomButton(
                        text: 'Confirm',
                        onPressed: () => _confirmAppointment(appt),
                        backgroundColor: const Color(0xFFB28CFF),
                        borderRadius: mq.width(2),
                        verticalPadding: mq.height(1.5),
                        fontSize: mq.width(3.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (!isConfirmed) SizedBox(width: mq.width(3)),
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      onPressed: () => _cancelAppointment(appt),
                      backgroundColor: Colors.white,
                      textColor: Colors.black87,
                      borderRadius: mq.width(2),
                      verticalPadding: mq.height(1.5),
                      fontSize: mq.width(3.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _confirmAppointment(Appointment appt) async {
    // Update appointment status in Firestore
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appt.id)
          .update({
        'status': 'confirmed',
      });
      // No need to refresh as we're using a stream listener in _fetchAppointments
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error confirming appointment: $e')),
      );
    }
  }

  void _cancelAppointment(Appointment appt) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appt.id)
          .update({
        'status': 'cancelled',
      });
      // No need to refresh as we're using a stream listener in _fetchAppointments
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error canceling appointment: $e')),
      );
    }
  }
}
