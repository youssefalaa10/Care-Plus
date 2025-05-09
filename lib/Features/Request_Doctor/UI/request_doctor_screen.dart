import 'package:careplus/Core/styles/color_manager.dart';
import 'package:careplus/Core/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Core/Routing/routes.dart';
import '../../../Core/styles/image_manager.dart';
import '../../Top-Doctors/Data/Model/doctor_model.dart';
import '../../Top-Doctors/Logic/doctor_cubit.dart';

class RequestDoctorScreen extends StatefulWidget {
  const RequestDoctorScreen({super.key});

  @override
  State<RequestDoctorScreen> createState() => _RequestDoctorScreenState();
}

class _RequestDoctorScreenState extends State<RequestDoctorScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = 'All Locations';
  bool isSearchExpanded = false;
  int? _selectedSpecialtyIndex;
  List<String> _availableLocations = ['All Locations'];
  bool _isLoadingLocations = true;

  @override
  void initState() {
    super.initState();

    context.read<DoctorCubit>().loadDoctors();

    _searchController.addListener(_onSearchChanged);

    _fetchLocations();
  }

  void _fetchLocations() async {
    setState(() {
      _isLoadingLocations = true;
    });

    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('doctors').get();

      final Set<String> locations = {'All Locations'};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data['location'] != null) {
          locations.add(data['location'] as String);
        }
      }

      setState(() {
        _availableLocations = locations.toList();
        _isLoadingLocations = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocations = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    context.read<DoctorCubit>().searchDoctors(query);
  }

  List<DoctorModel> _filterDoctors(List<DoctorModel> doctors) {
    return doctors.where((doctor) {
      final bool matchesLocation = _selectedLocation == 'All Locations' ||
          doctor.location == _selectedLocation;

      final bool matchesSpecialty = _selectedSpecialtyIndex == null ||
          doctor.speciality.toLowerCase().contains(
              _specialties[_selectedSpecialtyIndex!]['name']!
                  .replaceAll('\n', ' ')
                  .toLowerCase());

      return matchesLocation && matchesSpecialty;
    }).toList();
  }

  final List<Map<String, String>> _specialties = [
    {
      'name': 'Child\nSpecialist',
      'icon': ImageManager.topDoctorIcon,
    },
    {
      'name': 'Cardiology',
      'icon': ImageManager.cardiologyIcon,
    },
    {
      'name': 'Medicine',
      'icon': ImageManager.medicineIcon,
    },
    {
      'name': 'General',
      'icon': ImageManager.generalIcon,
    },
  ];

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 20.h),
              _buildSearchBar(),
              SizedBox(height: 24.h),
              _buildCategoriesSection(),
              SizedBox(height: 20.h),
              Expanded(
                child: BlocBuilder<DoctorCubit, DoctorState>(
                  builder: (context, state) {
                    if (state is DoctorLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DoctorsLoaded) {
                      final doctors = _filterDoctors(state.doctors);
                      if (doctors.isEmpty) {
                        return const Center(child: Text('No doctors found'));
                      }
                      return ListView.builder(
                          itemCount: doctors.length,
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.doctorDetailsScreen,
                                    arguments: doctors[index],
                                  );
                                },
                                child: Card(
                                  margin: EdgeInsets.symmetric(vertical: 8.h),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.r),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 25.r,
                                        backgroundImage: NetworkImage(
                                          doctors[index].imageUrl,
                                        ),
                                        onBackgroundImageError: (_, __) {},
                                        backgroundColor: ColorManager.grey200,
                                        child: doctors[index].imageUrl.isEmpty
                                            ? Icon(Icons.person, size: 30.sp)
                                            : null,
                                      ),
                                      title: Text(
                                        doctors[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doctors[index].speciality,
                                            style: TextStyle(fontSize: 14.sp),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on,
                                                  size: 14.sp,
                                                  color: Colors.grey),
                                              SizedBox(width: 4.w),
                                              Expanded(
                                                child: Text(
                                                  doctors[index].location,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.grey[600],
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              Routes.doctorDetailsScreen, arguments: doctors[index]);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorManager.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 8.h,
                                          ),
                                        ),
                                        child: Text(
                                          'Book',
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: ColorManager.white),
                                        ),
                                      ),
                                      isThreeLine: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 8.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                    } else if (state is DoctorError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, size: 24.sp),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Find Doctors in',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(width: 8.w),
              _isLoadingLocations
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            ColorManager.primaryColor),
                      ),
                    )
                  : DropdownButton<String>(
                      value: _selectedLocation,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      elevation: 16,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      underline: Container(height: 0),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedLocation = newValue;
                          });

                          context.read<DoctorCubit>().loadDoctors();
                        }
                      },
                      items: _availableLocations
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16.sp,
          ),
          prefixIcon: Icon(
            IconBroken.search,  
            color: Colors.purple,
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.h),
        ),
        onTap: () {
          setState(() {
            isSearchExpanded = true;
          });
        },
        onSubmitted: (_) {
          setState(() {
            isSearchExpanded = false;
          });
        },
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search by catagories',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
          ),
          itemCount: _specialties.length,
          itemBuilder: (context, index) {
            return _buildSpecialtyCard(
              name: _specialties[index]['name']!,
              iconPath: _specialties[index]['icon']!,
              index: index,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSpecialtyCard(
      {required String name, required String iconPath, required int index}) {
    final bool isSelected = _selectedSpecialtyIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSpecialtyIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 65.w,
            height: 65.h,
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorManager.primaryColor.withValues(alpha: 0.3)
                  : ColorManager.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: isSelected
                  ? Border.all(color: Colors.purple, width: 2)
                  : null,
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 40.w,
                height: 40.h,
                color: Colors.purple,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          SizedBox(
            height: 34.h,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.purple : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
