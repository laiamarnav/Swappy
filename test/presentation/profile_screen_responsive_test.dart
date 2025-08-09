import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:swappy/screens/profile_screen.dart';

Future<void> _pump(WidgetTester tester, double width) async {
  await tester.binding.setSurfaceSize(Size(width, 800));
  await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('uses column layout on phone', (tester) async {
    await _pump(tester, 390);
    // In phone layout the content is wrapped in a ListView (column-like)
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(Row), findsNothing);
  });

  testWidgets('uses row layout on wide screens', (tester) async {
    await _pump(tester, 840);
    expect(find.byType(Row), findsWidgets);
  });

  testWidgets('row layout persists on desktop', (tester) async {
    await _pump(tester, 1200);
    expect(find.byType(Row), findsWidgets);
  });
}
