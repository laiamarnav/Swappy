import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.notifications,
                  color: currentIndex == 0 ? Colors.blue : Colors.grey),
              onPressed: () => onTap(0),
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: Icon(Icons.person,
                  color: currentIndex == 2 ? Colors.blue : Colors.grey),
              onPressed: () => onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}
