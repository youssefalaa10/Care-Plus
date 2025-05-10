import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:careplus/Features/Auth/logic/auth_cubit.dart';
import 'package:careplus/Features/Auth/logic/auth_state.dart';
import 'package:careplus/Core/Routing/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration splashDelay = Duration(seconds: 2);
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _setupAnimation();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAuthStatus());
  }
  
  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }
  Future<void> _checkAuthStatus() async {
    await Future.delayed(splashDelay);
    if (mounted) {
      context.read<AuthCubit>().checkAuthStatus();
    }
  }
  void _navigateToNextScreen(AuthStatus status) {
    if (!mounted) return;
    final route = (status == AuthStatus.authenticated)
        ? Routes.mainLayout
        : Routes.loginScreen;
    Navigator.pushReplacementNamed(context, route);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated ||
            state.status == AuthStatus.unauthenticated) {
          _navigateToNextScreen(state.status);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF9370DB),
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildSplashContent(),
          ),
        ),
      ),
    );
  }
  Widget _buildSplashContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.health_and_safety,
          size: 80,
          color: Colors.white,
        ),
        const SizedBox(height: 24),
        const Text(
          'Care Plus',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}