import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/components/media_query.dart';
import '../../../Features/Top-Doctors/Data/Model/doctor_model.dart';
import '../../../Features/Top-Doctors/Logic/doctor_cubit.dart';
import '../../../Features/Auth/Data/Model/user_model.dart';
import '../../../Features/Auth/logic/auth_cubit.dart';
import '../../../Features/Auth/logic/auth_state.dart';
import 'widgets/doctor_profile_section.dart';
import 'widgets/doctor_stats_section.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final DoctorModel doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  int selectedDayIndex = 0;
  int selectedTimeIndex = -1;

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final selectedDaySchedule = widget.doctor.daySchedules[selectedDayIndex];
    final selectedTimeSlot = (selectedTimeIndex == -1)
        ? null
        : selectedDaySchedule.availableHours[selectedTimeIndex];
    final selectedDay = selectedDaySchedule.day;
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
              DoctorProfileSection(doctor: widget.doctor),
              SizedBox(height: mq.height(3)),
              const DoctorStatsSection(),
              SizedBox(height: mq.height(3)),
              AboutDoctorSection(doctor: widget.doctor),
              SizedBox(height: mq.height(3)),
              ScheduleSection(
                doctor: widget.doctor,
                selectedIndex: selectedDayIndex,
                onDaySelected: (index) {
                  setState(() {
                    selectedDayIndex = index;
                    selectedTimeIndex = -1;
                  });
                },
              ),
              SizedBox(height: mq.height(3)),
              VisitHourSection(
                doctor: widget.doctor,
                selectedDayIndex: selectedDayIndex,
                selectedTimeIndex: selectedTimeIndex,
                onTimeSelected: (index) {
                  setState(() {
                    selectedTimeIndex = index;
                  });
                },
              ),
              SizedBox(height: mq.height(4)),
              BookingButton(
                doctor: widget.doctor,
                selectedDay: selectedTimeIndex == -1 ? null : selectedDay,
                selectedTimeSlot: selectedTimeSlot,
              ),
              SizedBox(height: mq.height(4)),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutDoctorSection extends StatelessWidget {
  final DoctorModel doctor;

  const AboutDoctorSection({super.key, required this.doctor});

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
          doctor.about,
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
  final DoctorModel doctor;
  final int selectedIndex;
  final Function(int) onDaySelected;

  const ScheduleSection({
    super.key,
    required this.doctor,
    required this.selectedIndex,
    required this.onDaySelected,
  });

  @override
  State<ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends State<ScheduleSection> {
  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedules',
          style: TextStyle(
            fontSize: mq.width(4.5),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: mq.height(2)),
        SizedBox(
          height: mq.height(10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.doctor.daySchedules.length,
            itemBuilder: (context, index) {
              final daySchedule = widget.doctor.daySchedules[index];
              final isSelected = widget.selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  widget.onDaySelected(index);
                },
                child: _buildDateCard(
                  context,
                  (index + 6).toString(),
                  daySchedule.day,
                  isSelected,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard(
      BuildContext context, String date, String day, bool isSelected) {
    final mq = CustomMQ(context);
    return Container(
      margin: EdgeInsets.only(right: mq.width(3)),
      width: mq.width(19),
      height: mq.height(8),
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
        mainAxisAlignment: MainAxisAlignment.center,
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
  final DoctorModel doctor;
  final int selectedDayIndex;
  final int selectedTimeIndex;
  final Function(int) onTimeSelected;

  const VisitHourSection({
    super.key,
    required this.doctor,
    required this.selectedDayIndex,
    required this.selectedTimeIndex,
    required this.onTimeSelected,
  });

  @override
  State<VisitHourSection> createState() => _VisitHourSectionState();
}

class _VisitHourSectionState extends State<VisitHourSection> {
  int selectedTimeIndex = -1;

  TimeSlot? get selectedTimeSlot {
    if (selectedTimeIndex == -1) return null;
    final selectedDaySchedule =
        widget.doctor.daySchedules[widget.selectedDayIndex];
    return selectedDaySchedule.availableHours[selectedTimeIndex];
  }

  String get selectedDay {
    return widget.doctor.daySchedules[widget.selectedDayIndex].day;
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    final selectedDaySchedule =
        widget.doctor.daySchedules[widget.selectedDayIndex];
    final availableHours = selectedDaySchedule.availableHours;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visit Hours (${selectedDaySchedule.day})',
          style: TextStyle(
            fontSize: mq.width(4.5),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: mq.height(2)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: availableHours.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: mq.width(3),
            mainAxisSpacing: mq.height(2),
            childAspectRatio: 3,
          ),
          itemBuilder: (context, index) {
            final timeSlot = availableHours[index];
            final isSelected = selectedTimeIndex == index;
            final isBooked = timeSlot.isBooked;

            return GestureDetector(
              onTap: isBooked
                  ? null
                  : () {
                      setState(() {
                        selectedTimeIndex = index;
                      });
                      widget.onTimeSelected(index);
                    },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: mq.width(4),
                  vertical: mq.height(1.2),
                ),
                decoration: BoxDecoration(
                  color: isBooked
                      ? Colors.grey[300]
                      : isSelected
                          ? const Color(0xFFB28CFF)
                          : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isBooked
                        ? Colors.grey[300]!
                        : isSelected
                            ? const Color(0xFFB28CFF)
                            : Colors.grey.shade300,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${timeSlot.startTime} - ${timeSlot.endTime}',
                  style: TextStyle(
                    fontSize: mq.width(3.2),
                    color: isBooked
                        ? Colors.grey[500]
                        : isSelected
                            ? Colors.white
                            : Colors.grey[600],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class BookingButton extends StatelessWidget {
  final DoctorModel doctor;
  final String? selectedDay;
  final TimeSlot? selectedTimeSlot;

  const BookingButton(
      {super.key,
      required this.doctor,
      required this.selectedDay,
      required this.selectedTimeSlot});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    return BlocListener<DoctorCubit, DoctorState>(
      listener: (context, state) {
        if (state is AppointmentBookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appointment booked successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AppointmentBookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final UserModel? currentUser = authState.user;

          return BlocBuilder<DoctorCubit, DoctorState>(
            builder: (context, state) {
              final isLoading = state is AppointmentBookingLoading;
              final isDisabled = selectedDay == null ||
                  selectedTimeSlot == null ||
                  currentUser == null ||
                  isLoading;
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isDisabled
                      ? null
                      : () {
                          context.read<DoctorCubit>().bookAppointment(
                                doctorId: doctor.id,
                                userId: currentUser.uid,
                                day: selectedDay!,
                                timeSlot: selectedTimeSlot!,
                              );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB28CFF),
                    padding: EdgeInsets.symmetric(vertical: mq.height(2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Text(
                    isLoading ? 'Booking...' : 'Book Appointment',
                    style: TextStyle(
                      color: isDisabled ? Colors.grey[600] : Colors.white,
                      fontSize: mq.width(4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
