import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class Storage {
  static const String _usersKey = 'cached_users';
  static const String _timestampKey = 'cache_timestamp';

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
      await prefs.setString(_usersKey, json.encode(jsonList));
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

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }
}
