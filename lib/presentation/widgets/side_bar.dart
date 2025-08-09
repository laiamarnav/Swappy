import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;

  const SideBar({super.key, required this.currentIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final items = [
      _SideBarItem(
        icon: Icons.notifications,
        label: 'Notificaciones',
        selected: currentIndex == 0,
        onTap: () => onSelect(0),
      ),
      _SideBarItem(
        icon: Icons.search,
        label: 'Buscar',
        selected: currentIndex == 1,
        onTap: () => onSelect(1),
      ),
      _SideBarItem(
        icon: Icons.person,
        label: 'Perfil',
        selected: currentIndex == 2,
        onTap: () => onSelect(2),
      ),
    ];

    return Container(
      color: const Color(0xFFF6ECFF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((e) => Expanded(child: e)).toList(),
      ),
    );
  }
}

class _SideBarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SideBarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_SideBarItem> createState() => _SideBarItemState();
}

class _SideBarItemState extends State<_SideBarItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF3F6FFF);
    final bg = widget.selected
        ? const Color(0xFFE5ECFF)
        : _hover
            ? const Color(0xFFE5ECFF).withOpacity(0.6)
            : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: widget.selected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  color: widget.selected ? primary : Colors.grey,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.selected ? primary : Colors.grey,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

