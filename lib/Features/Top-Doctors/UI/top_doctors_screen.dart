import 'package:careplus/Core/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/DI/dependency_injection.dart';
import '../../../Core/components/media_query.dart';
import '../../../Core/styles/image_manager.dart';
import '../Data/Model/doctor_model.dart';
import '../Logic/doctor_cubit.dart';
import '../../Doctor-Details/UI/doctor_details_screen.dart';

class TopDoctors extends StatefulWidget {
  const TopDoctors({super.key});

  @override
  State<TopDoctors> createState() => _TopDoctorsState();
}

class _TopDoctorsState extends State<TopDoctors> {
  @override
  void initState() {
    super.initState();
    // Load doctors when screen initializes
    context.read<DoctorCubit>().loadTopRatedDoctors();
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Top Doctors',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width(5),
              vertical: mq.height(2),
            ),
            child: SearchBar(mq: mq),
          ),
          Expanded(
            child: BlocBuilder<DoctorCubit, DoctorState>(
              builder: (context, state) {
                if (state is DoctorLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DoctorsLoaded) {
                  final doctors = state.doctors;
                  if (doctors.isEmpty) {
                    return const Center(child: Text('No doctors found'));
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) => DoctorCard(
                      doctor: doctors[index],
                      mq: mq,
                    ),
                  );
                } else if (state is DoctorError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  // If no state is available yet, trigger loading
                  // This ensures we always try to load from Firestore
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<DoctorCubit>().loadTopRatedDoctors();
                  });
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final CustomMQ mq;

  const SearchBar({super.key, required this.mq});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: mq.width(4),
        vertical: mq.height(1),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(IconBroken.search, size: 25.0, color: Colors.grey[500]),
          SizedBox(width: mq.width(3)),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Doctor',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: mq.width(3.8),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final CustomMQ mq;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.mq,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: mq.height(2)),
      padding: EdgeInsets.all(mq.width(3)),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Column(
            children: [
              buildDoctorImage(),
              SizedBox(height: mq.height(1)),
              _buildRatingBelowImage(),
            ],
          ),
          SizedBox(width: mq.width(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: TextStyle(
                    fontSize: mq.width(4),
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: mq.height(0.5)),
                Text(
                  doctor.speciality,
                  style: TextStyle(
                    fontSize: mq.width(3.2),
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: mq.height(1)),
                _buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDoctorImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        doctor.imageUrl,
        width: mq.width(16),
        height: mq.width(16),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: mq.width(16),
            height: mq.width(16),
            color: Colors.grey[200],
            child: const Icon(Icons.person, size: 40),
          );
        },
      ),
    );
  }

  Widget _buildRatingBelowImage() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          ImageManager.starIcons,
          width: mq.width(4),
          height: mq.width(4),
        ),
        SizedBox(width: mq.width(1)),
        Text(
          doctor.rating.toString(),
          style: TextStyle(
            fontSize: mq.width(3.5),
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => getIt<DoctorCubit>(),
                  child: DoctorDetailsScreen(doctor: doctor),
                ),
              ),
            );
          },
          child: _buildActionButton(
            'Appointment',
            textColor: Colors.black87,
          ),
        ),
        SizedBox(width: mq.width(2)),
        Container(
          padding: EdgeInsets.all(mq.width(1.5)),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8F8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            ImageManager.messageIcon,
            width: mq.width(4),
            height: mq.width(4),
          ),
        ),
        SizedBox(width: mq.width(2)),
        _buildIconButton(Icons.favorite_border),
      ],
    );
  }

  Widget _buildActionButton(String text, {required Color textColor}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: mq.width(3),
        vertical: mq.height(0.8),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: mq.width(3),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: EdgeInsets.all(mq.width(1.5)),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F8), // Fixed color for all icon buttons
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: mq.width(4),
        color: Colors.black87, // Icon color
      ),
    );
  }
}

// Doctor model is now defined in the Data/Model directory
