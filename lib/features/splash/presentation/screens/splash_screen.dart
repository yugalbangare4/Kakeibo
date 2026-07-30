import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        context.go('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1C), // Deep sleek dark background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amberAccent.withOpacity(0.15),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            )
            .animate()
            .scale(duration: 1000.ms, curve: Curves.easeOutBack, begin: const Offset(0.5, 0.5))
            .fadeIn(duration: 800.ms)
            .shimmer(duration: 2000.ms, delay: 1000.ms, color: Colors.white24),
            
            const SizedBox(height: 40),
            
            // App Name
            Text(
              'KAKEIBO',
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: 10,
                color: Colors.white,
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms, delay: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 800.ms, curve: Curves.easeOutCubic),
            
            const SizedBox(height: 16),
            
            // Subtitle
            Text(
              'MINDFUL SPENDING',
              style: GoogleFonts.inter(
                fontSize: 14,
                letterSpacing: 6,
                color: Colors.white60,
                fontWeight: FontWeight.w500,
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms, delay: 800.ms),
          ],
        ),
      ),
    );
  }
}
