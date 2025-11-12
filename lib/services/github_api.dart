import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/repo.dart';

class GithubApi {
  final Dio dio;
  static const String baseUrl = 'https://api.github.com';

  GithubApi() : dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<List<User>> getUsers() async {
    try {
      final response = await dio.get('/users');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => User.fromJson(json)).toList();
      }
      throw Exception('Failed to load users');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<User> getUser(String username) async {
    try {
      final response = await dio.get('/users/$username');
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      throw Exception('Failed to load user');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Repo>> getRepos(String username) async {
    try {
      final response = await dio.get('/users/$username/repos');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Repo.fromJson(json)).toList();
      }
      throw Exception('Failed to load repos');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
