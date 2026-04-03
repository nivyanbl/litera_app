import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomBottomNavbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavbar({
    super.key,
    this.currentIndex = 0,
    required this.onTap,
  });

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          widget.onTap(index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryNormal,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book),
            activeIcon: const Icon(Icons.menu_book),
            label: 'Buku Saya',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            activeIcon: const Icon(Icons.person_outline_rounded),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
