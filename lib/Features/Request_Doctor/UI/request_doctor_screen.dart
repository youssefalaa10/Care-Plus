import 'package:carepulse/Core/styles/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/styles/image_manager.dart';

class RequestDoctorScreen extends StatefulWidget {
  const RequestDoctorScreen({super.key});

  @override
  State<RequestDoctorScreen> createState() => _RequestDoctorScreenState();
}

class _RequestDoctorScreenState extends State<RequestDoctorScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = 'NewYork';
  bool isSearchExpanded = false;
  int? _selectedSpecialtyIndex;

  // List of medical specialties with their icons
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
                child: Center(
                  
                  child: _selectedSpecialtyIndex != null
                      ? Text(
                          'Showing doctors for ${_specialties[_selectedSpecialtyIndex!]['name']!.replaceAll('\n', ' ')}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.purple,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          'Select a specialty to find doctors',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
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
        // Menu Icon
        IconButton(
          icon: Icon(Icons.arrow_back, size: 24.sp),
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),

        // Location Selector
        Row(
          children: [
            Text(
              'Find Doctors in',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 8.w),
            DropdownButton<String>(
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
                }
              },
              items: <String>['NewYork', 'Los Angeles', 'Chicago', 'Houston']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),

        // Notification Icon
        IconButton(
          icon: Icon(Icons.notifications_outlined, size: 24.sp),
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
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
            Icons.search,
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
        // Categories Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Search by catagories',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20.sp,
              color: Colors.grey,
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Categories Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600
                ? 4
                : 3, // Responsive grid
            childAspectRatio: 0.8, // Adjusted for better proportions
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
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
            width: 70.w,
            height: 70.h,
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
            height: 36.h, // Fixed height for text container
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
