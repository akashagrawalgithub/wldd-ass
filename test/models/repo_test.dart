import 'package:flutter_test/flutter_test.dart';
import 'package:wldd_assignment/models/repo.dart';

void main() {
  test('Repo fromJson works', () {
    final json = {
      'id': 123,
      'name': 'test-repo',
      'description': 'Test repo',
      'stargazers_count': 10,
      'forks_count': 5,
    };

    final repo = Repo.fromJson(json);

    expect(repo.name, 'test-repo');
    expect(repo.stars, 10);
    expect(repo.forks, 5);
  });
}
