import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../core/responsive/responsive.dart';
import 'side_bar.dart';

class AdaptiveScaffold extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final Widget body;
  final Widget? fab;

  const AdaptiveScaffold({
    super.key,
    required this.currentIndex,
    required this.onSelect,
    required this.body,
    this.fab,
  });

  Color _iconColor(int idx) =>
      currentIndex == idx ? Colors.white : Colors.grey;

  @override
  Widget build(BuildContext context) {
    if (context.isTablet || context.isDesktop) {
      final width = context.isDesktop ? 96.0 : 80.0;
      return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: fab,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Row(
          children: [
            SizedBox(
              width: width,
              child: SideBar(
                currentIndex: currentIndex,
                onSelect: onSelect,
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: body,
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        height: 75,
        items: [
          Icon(Icons.notifications, size: 22, color: _iconColor(0)),
          Icon(Icons.search,        size: 22, color: _iconColor(1)),
          Icon(Icons.person,        size: 22, color: _iconColor(2)),
        ],
        color: const Color(0xFFF7F7F7),
        buttonBackgroundColor: Colors.blue,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: onSelect,
      ),
    );
  }
}
