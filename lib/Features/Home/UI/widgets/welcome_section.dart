import 'package:carepulse/Core/Routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/components/media_query.dart';
import '../../../../Core/styles/icon_broken.dart';
import '../../../../Core/styles/image_manager.dart';
import '../../../Auth/logic/auth_cubit.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF9370DB),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const HeaderSection(),
            ],
          ),
          // const SizedBox(height: 10),
          const Text(
            "Let's find\nyour top doctor!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search health issue....',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
                icon: const Icon(IconBroken.search,
                    size: 20.0, color: Color.fromARGB(255, 11, 11, 11)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Profile Icon with Dropdown
        PopupMenuButton<String>(
          offset: Offset(0, mq.height(5)),
          icon: CircleAvatar(
            radius: mq.width(5),
            backgroundImage: AssetImage(ImageManager.doctor1),
            backgroundColor: Colors.grey[300],
          ),
          onSelected: (value) {
            if (value == 'logout') {
              // Handle logout action
              _handleLogout(context);
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red[400]),
                  SizedBox(width: mq.width(2)),
                  const Text('Logout'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings, color: Colors.grey[700]),
                  SizedBox(width: mq.width(2)),
                  const Text('Settings'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleLogout(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement actual logout logic here
                // For example:
                context.read<AuthCubit>().signOut();

                // Close dialog
                Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);

                // Display logout message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );

                // Navigate to login screen
                // Navigator.pushReplacementNamed(context, Routes.loginScreen);
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
