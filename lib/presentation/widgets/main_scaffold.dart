// lib/widgets/main_scaffold.dart

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class MainScaffold extends StatefulWidget {
  final int currentIndex;
  final Widget child;

  const MainScaffold({
    Key? key,
    required this.currentIndex,
    required this.child,
  }) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;

  final _routes = ['/notifications', '/search', '/profile'];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onTap(int index) {
    if (index == _currentIndex) return;
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  void _goToCreate() {
    Navigator.of(context).pushNamed('/create');
  }

  Color _iconColor(int idx) =>
      _currentIndex == idx ? Colors.white : Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,

      // tu contenido variable
      body: widget.child,

      // FAB común
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          onPressed: _goToCreate,
          backgroundColor: Colors.blue,
          tooltip: 'Publicar anuncio',
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // barra curva
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
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
        onTap: _onTap,
      ),
    );
  }
}
