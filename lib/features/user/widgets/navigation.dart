import 'package:flutter/material.dart';
import '../home/pages/home_page.dart';
import '../forum/pages/forum_page.dart';
import '../chat/pages/chat_page.dart';
import '../profile/pages/profile_page.dart';
import '../consultation/pages/consultation_page.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ConsultationPage(),
    ChatPage(),
    ForumPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _buildCenterButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 78,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: 'assets/navbar/home.png', index: 0),

              _buildNavItem(icon: 'assets/navbar/journal.png', index: 1),

              const SizedBox(width: 68),

              _buildNavItem(icon: 'assets/navbar/forum.png', index: 3),

              _buildNavItem(icon: 'assets/navbar/profile.png', index: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required String icon, required int index}) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Image.asset(
          icon,
          width: 32,
          height: 32,
          color: isSelected ? const Color(0xFF3D8BFF) : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return Transform.translate(
      offset: const Offset(0, 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
        },
        child: Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: Color(0xFF3D8BFF),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              'assets/navbar/chatbot.png',
              width: 38,
              height: 38,
            ),
          ),
        ),
      ),
    );
  }
}
