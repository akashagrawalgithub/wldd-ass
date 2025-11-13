import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wldd_assignment/services/storage.dart';
import 'package:wldd_assignment/models/user.dart';

void main() {
  test('Storage saves and gets users', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = Storage();
    final users = [User(login: 'testuser', id: 123)];

    await storage.saveUsers(users);
    final result = await storage.getUsers();

    expect(result, isNotNull);
    expect(result!.length, 1);
  });
}
