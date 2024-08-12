import 'package:flutter/material.dart';
import 'package:medlens/screens/hidden_drawer.dart';
import 'package:medlens/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Simulate some initialization process or validation (e.g., check if the user is logged in)
    await Future.delayed(const Duration(seconds: 3));

    bool isLoggedIn = await _checkUserLoggedIn();

    if (isLoggedIn) {
      // Navigate to HomeScreen if user is logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      //Navigate to HiddenDrawer if user is not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HiddenDrawer()),
      );
    }
  }

  Future<bool> _checkUserLoggedIn() async {
    // Implement your logic here to check if the user is logged in
    // For example, check shared preferences or secure storage
    // Return true if the user is logged in, otherwise return false
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 1.0],
            colors: [
              Color(0xFFA5BB9E), // Light Green
              Color(0xFFB4BFBC), // Dark Gray/Green
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_hospital,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                color: Colors.white,
                ),
              // App Icon
              // Image.asset(
              //   'assets/app_icon.png', // Replace with your app icon path
              //   width: 100,
              //   height: 100,
              // ),
              // const SizedBox(height: 20),
              // const CircularProgressIndicator(
              //   color: Colors.white,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
