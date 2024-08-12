import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:medlens/screens/home_screen.dart';
import 'package:medlens/screens/profile_screen.dart'; // Assuming you have a ProfileScreen

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];
  List<String> _conversationHistory = [];

  @override
  void initState() {
    super.initState();
    _loadConversationHistory();

    // Adding profile item as the first item
    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Profile",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 25.0),
          selectedStyle: const TextStyle(color: Colors.teal),
        ),
        const ProfileScreen(
          username: 'Kaif Shaheem',
          email: 'kaifshaheemj17@gmail.com',
          profileImageUrl: '',
        ), // Assuming you have a ProfileScreen
      ),
      // Placeholder for other pages
    ];
  }

  Future<void> _loadConversationHistory() async {
    List<String> history = await _fetchConversationHistory();
    setState(() {
      _conversationHistory = history;
      for (var conversation in _conversationHistory) {
        _pages.add(ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: conversation,
            baseStyle: TextStyle(
                color: Color.fromARGB(255, 49, 39, 39).withOpacity(0.8),
                fontSize: 20.0),
            selectedStyle: const TextStyle(color: Colors.teal),
          ),
          HomeScreen(), // Replace with a screen to display conversation details
        ));
      }
    });
  }

  Future<List<String>> _fetchConversationHistory() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [
      'Alembic Pharmaceuticals',
      'Sanctus Pharmaceuticals',
      'Cipla Pharmaceuticals'
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      screens: _pages,
      backgroundColorMenu: const Color.fromARGB(255, 215, 250, 218),
      initPositionSelected: 0,
      slidePercent: 40.0, // Adjusts the drawer sliding speed
      curveAnimation:
          Curves.easeInOutCubic, // Adjusts the drawer animation curve
    );
  }
}
