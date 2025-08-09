import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:swappy/presentation/widgets/main_scaffold.dart';

Future<void> _pump(WidgetTester tester, double width) async {
  await tester.binding.setSurfaceSize(Size(width, 800));
  await tester.pumpWidget(
    MaterialApp(
      home: MainScaffold(currentIndex: 0, child: const SizedBox()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('uses bottom navigation on phone', (tester) async {
    await _pump(tester, 390);
    expect(find.byType(CurvedNavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('uses navigation rail on tablet', (tester) async {
    await _pump(tester, 840);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(CurvedNavigationBar), findsNothing);
  });

  testWidgets('uses navigation rail on desktop', (tester) async {
    await _pump(tester, 1200);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(CurvedNavigationBar), findsNothing);
  });
}
