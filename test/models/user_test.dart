import 'package:flutter_test/flutter_test.dart';
import 'package:wldd_assignment/models/user.dart';

void main() {
  test('User fromJson works', () {
    final json = {
      'login': 'testuser',
      'id': 123,
      'avatar_url': 'https://example.com/avatar.jpg',
      'name': 'Test User',
    };

    final user = User.fromJson(json);

    expect(user.login, 'testuser');
    expect(user.id, 123);
    expect(user.name, 'Test User');
  });
}
