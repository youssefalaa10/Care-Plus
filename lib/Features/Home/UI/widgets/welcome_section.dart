import 'package:flutter/material.dart';

import '../../../../Core/components/media_query.dart';
import '../../../../Core/components/styles/icon_broken.dart';
import '../../../../Core/components/styles/image_manager.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
        final mq = CustomMQ(context);
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
              Image.asset(
                ImageManager.menu,
                width: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.transparent, width: 2),
                ),
                child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                         ImageManager.doctor1,
                        width: mq.width(12),
                        height: mq.width(12),
                        fit: BoxFit.cover,
                      ),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Welcome Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
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
