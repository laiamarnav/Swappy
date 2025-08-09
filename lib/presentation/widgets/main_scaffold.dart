// lib/widgets/main_scaffold.dart

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:swappy/core/responsive/responsive.dart';

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

  List<NavigationRailDestination> get _railDestinations => const [
        NavigationRailDestination(
          icon: Icon(Icons.notifications),
          label: Text('Notificaciones'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.search),
          label: Text('Buscar'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person),
          label: Text('Perfil'),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final fab = Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: FloatingActionButton(
        onPressed: _goToCreate,
        backgroundColor: Colors.blue,
        tooltip: 'Publicar anuncio',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );

    // Use a NavigationRail on larger screens and a curved bottom bar on phones.
    if (context.isTablet || context.isDesktop) {
      return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: fab,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              destinations: _railDestinations,
              onDestinationSelected: _onTap,
              labelType: NavigationRailLabelType.selected,
            ),
            const VerticalDivider(width: 1),
            Expanded(child: widget.child),
          ],
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: widget.child,
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
