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
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Connection timeout. Please check your internet.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection');
      } else {
        throw Exception('Failed to load users. Please try again.');
      }
    } catch (e) {
      throw Exception('Failed to load users');
    }
  }

  Future<User> getUser(String username) async {
    try {
      final response = await dio.get('/users/$username');
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      throw Exception('Failed to load user');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Connection timeout. Please check your internet.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection');
      } else {
        throw Exception('Failed to load user. Please try again.');
      }
    } catch (e) {
      throw Exception('Failed to load user');
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
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Connection timeout. Please check your internet.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection');
      } else {
        throw Exception('Failed to load repos. Please try again.');
      }
    } catch (e) {
      throw Exception('Failed to load repos');
    }
  }
}
