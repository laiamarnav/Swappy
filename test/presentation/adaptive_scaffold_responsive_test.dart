import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:swappy/presentation/widgets/adaptive_scaffold.dart';
import 'package:swappy/presentation/widgets/side_bar.dart';

Future<void> _pump(WidgetTester tester, double width) async {
  await tester.binding.setSurfaceSize(Size(width, 800));
  await tester.pumpWidget(
    MaterialApp(
      home: AdaptiveScaffold(
        currentIndex: 0,
        onSelect: (_) {},
        body: const SizedBox(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('uses bottom navigation on phone', (tester) async {
    await _pump(tester, 390);
    expect(find.byType(CurvedNavigationBar), findsOneWidget);
    expect(find.byType(SideBar), findsNothing);
  });

  testWidgets('uses side bar on tablet', (tester) async {
    await _pump(tester, 840);
    expect(find.byType(SideBar), findsOneWidget);
    expect(find.byType(CurvedNavigationBar), findsNothing);
  });

  testWidgets('uses side bar on desktop', (tester) async {
    await _pump(tester, 1200);
    expect(find.byType(SideBar), findsOneWidget);
    expect(find.byType(CurvedNavigationBar), findsNothing);
  });
}
