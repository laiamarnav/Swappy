import 'package:flutter/material.dart';

class AnimatedBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AnimatedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AnimatedBottomNavBar> createState() => _AnimatedBottomNavBarState();
}

class _AnimatedBottomNavBarState extends State<AnimatedBottomNavBar>
    with SingleTickerProviderStateMixin {
  late double _indicatorPosition;

  @override
  void initState() {
    super.initState();
    _indicatorPosition = widget.currentIndex.toDouble();
  }

  @override
  void didUpdateWidget(covariant AnimatedBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      setState(() => _indicatorPosition = widget.currentIndex.toDouble());
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = 28.0;
    final items = [
      Icons.notifications,
      Icons.search,
      Icons.person,
    ];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final isSelected = widget.currentIndex == i;
                return GestureDetector(
                  onTap: () => widget.onTap(i),
                  child: Icon(
                    items[i],
                    size: iconSize,
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          bottom: 40,
          left: MediaQuery.of(context).size.width / 6 * (1 + 2 * _indicatorPosition) - iconSize / 2,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue, width: 2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              items[widget.currentIndex],
              size: 20,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
