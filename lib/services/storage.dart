import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/repo.dart';

class Storage {
  static const String _usersKey = 'cached_users';
  static const String _timestampKey = 'cache_timestamp';
  static const String _userDetailsPrefix = 'user_detail_';
  static const String _userReposPrefix = 'user_repos_';
  static const String _userDetailsTimestampPrefix = 'user_detail_timestamp_';
  static const String _userReposTimestampPrefix = 'user_repos_timestamp_';

  Future<void> saveUsers(List<User> users) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = users
          .map(
            (user) => {
              'login': user.login,
              'id': user.id,
              'avatar_url': user.avatarUrl,
              'name': user.name,
              'bio': user.bio,
              'followers': user.followers,
              'following': user.following,
              'public_repos': user.publicRepos,
            },
          )
          .toList();
      await prefs.setString(_usersKey, jsonEncode(jsonList));
      await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {}
  }

  Future<List<User>?> getUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_timestampKey);
      if (timestamp == null) return null;

      final cacheAge = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(timestamp),
      );
      if (cacheAge.inHours > 1) return null;

      final jsonString = prefs.getString(_usersKey);
      if (jsonString == null) return null;

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUserDetail(String username, User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = {
        'login': user.login,
        'id': user.id,
        'avatar_url': user.avatarUrl,
        'name': user.name,
        'bio': user.bio,
        'followers': user.followers,
        'following': user.following,
        'public_repos': user.publicRepos,
      };
      await prefs.setString(
        _userDetailsPrefix + username,
        jsonEncode(userJson),
      );
      await prefs.setInt(
        _userDetailsTimestampPrefix + username,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {}
  }

  Future<User?> getUserDetail(String username) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_userDetailsTimestampPrefix + username);
      if (timestamp == null) return null;

      final cacheAge = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(timestamp),
      );
      if (cacheAge.inHours > 24) return null;

      final jsonString = prefs.getString(_userDetailsPrefix + username);
      if (jsonString == null) return null;

      final Map<String, dynamic> userJson = jsonDecode(jsonString);
      return User.fromJson(userJson);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUserRepos(String username, List<Repo> repos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = repos
          .map(
            (repo) => {
              'id': repo.id,
              'name': repo.name,
              'description': repo.description,
              'language': repo.language,
              'stargazers_count': repo.stars,
              'forks_count': repo.forks,
            },
          )
          .toList();
      await prefs.setString(_userReposPrefix + username, jsonEncode(jsonList));
      await prefs.setInt(
        _userReposTimestampPrefix + username,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {}
  }

  Future<List<Repo>?> getUserRepos(String username) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_userReposTimestampPrefix + username);
      if (timestamp == null) return null;

      final cacheAge = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(timestamp),
      );
      if (cacheAge.inHours > 24) return null;

      final jsonString = prefs.getString(_userReposPrefix + username);
      if (jsonString == null) return null;

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Repo.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }
}
