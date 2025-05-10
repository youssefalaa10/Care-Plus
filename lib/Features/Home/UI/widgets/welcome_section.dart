import 'package:careplus/Core/Routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/components/media_query.dart';
import '../../../../Core/styles/icon_broken.dart';
import '../../../Auth/logic/auth_cubit.dart';

class WelcomeSection extends StatelessWidget {
  final void Function(String)? onSearchChanged;
  const WelcomeSection({super.key, this.onSearchChanged});

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
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search for Doctor....',
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
        PopupMenuButton<String>(
          offset: Offset(0, mq.height(5)),
          icon: Container(
              height: mq.height(4),
              width: mq.height(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: Icon(IconBroken.profile,
                  size: mq.width(6), color: Colors.white)),
          onSelected: (value) {
            if (value == 'logout') {
              _handleLogout(context);
            }
            if (value == 'settings') {
              Navigator.pushNamed(context, Routes.profileScreen);
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
  final navigator = Navigator.of(context); 

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => navigator.pop(), 
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              navigator.pop(); 

              await context.read<AuthCubit>().signOut();

              navigator.pushNamedAndRemoveUntil(
                  Routes.loginScreen, (route) => false);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}


}
