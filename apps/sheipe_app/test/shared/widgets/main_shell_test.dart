import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheipe_app/shared/widgets/main_shell.dart';

void main() {
  group('MainShell', () {
    testWidgets('renders child and bottom nav bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainShell(child: Text('content')),
        ),
      );
      expect(find.text('content'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('bottom nav has Workout and Profile items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainShell(child: SizedBox()),
        ),
      );
      expect(find.text('Workout'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });
  });
}
