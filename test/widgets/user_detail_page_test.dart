import 'package:flutter_test/flutter_test.dart';
import 'package:wldd_assignment/screens/user_detail_page.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('UserDetailPage shows username', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: UserDetailPage(username: 'testuser')),
    );

    expect(find.text('testuser'), findsOneWidget);
  });
}
