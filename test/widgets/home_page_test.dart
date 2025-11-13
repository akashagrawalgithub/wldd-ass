import 'package:flutter_test/flutter_test.dart';
import 'package:wldd_assignment/screens/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('HomePage shows DevGallery title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.text('DevGallery'), findsOneWidget);
  });
}
