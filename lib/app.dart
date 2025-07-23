import 'package:flutter/material.dart';
import 'package:frc_scout_app/screens/splash_screen.dart';
import 'package:frc_scout_app/screens/login_screen.dart';
import 'package:frc_scout_app/pages/dashboard/dashboard.dart';

class FRCScoutApp extends StatelessWidget {
  const FRCScoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FRC Scout',
      initialRoute: '/',  // Splash screen as initial route
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const Dashboard(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('No route for ${settings.name}')),
        ),
      ),
    );
  }
}