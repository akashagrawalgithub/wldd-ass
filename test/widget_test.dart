import 'package:flutter_test/flutter_test.dart';
import 'package:wldd_assignment/main.dart';

void main() {
  testWidgets('App shows DevGallery', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('DevGallery'), findsOneWidget);
  });
}
