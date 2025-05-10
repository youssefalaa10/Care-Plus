import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/styles/color_manager.dart';

class NotFoundScreen extends StatelessWidget {
  final String? title;
  const NotFoundScreen({this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100.h),
            Icon(
              Icons.hide_source,
              size: 70.r,
              color: ColorManager.primaryColor,
            ),
            SizedBox(height: 8.h),
            Text(
              title ?? '',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: ColorManager.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
