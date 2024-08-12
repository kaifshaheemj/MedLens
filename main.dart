import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:medlens/consts.dart';
import 'package:medlens/screens/splash.dart';

void main() {
  Gemini.init(apiKey: GEMINI_API_KEY);
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme:
//             ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 218, 240, 211)),
//       ),
//       home: Scaffold(
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topRight,
//               end: Alignment.bottomLeft,
//               stops: [0.0, 1.0],
//               colors: [
//                 Color(0xFFA5BB9E), // Light Green
//                 Color(0xFFB4BFBC), // Dark Gray/Green
//               ],
//             ),
//           ),
//           child: const Center(
//             child: Text(
//               'Welcome to MedLens',
//               style: TextStyle(
//                 fontSize: 24,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedLens',
      theme: ThemeData(
        primaryColor: const Color(
            0xFFA5BB9E), // Primary background color changed to #A5BB9E
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
