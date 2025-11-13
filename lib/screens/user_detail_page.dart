import 'package:flutter/material.dart';
import '../services/github_api.dart';
import '../services/storage.dart';
import '../models/user.dart';
import '../models/repo.dart';

class UserDetailPage extends StatefulWidget {
  final String username;

  const UserDetailPage({super.key, required this.username});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final GithubApi _api = GithubApi();
  final Storage _storage = Storage();
  User? _user;
  List<Repo> _repos = [];
  bool _loading = false;
  bool _loadingRepos = false;
  bool _isOffline = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadRepos();
  }

  Future<void> _loadUser({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _storage.getUserDetail(widget.username);
      if (cached != null) {
        setState(() {
          _user = cached;
          _isOffline = true;
        });
        _loadUserFromApi();
        return;
      }

      final allUsers = await _storage.getUsers();
      if (allUsers != null) {
        final userFromList = allUsers.firstWhere(
          (u) => u.login == widget.username,
          orElse: () => allUsers.first,
        );
        if (userFromList.login == widget.username) {
          setState(() {
            _user = userFromList;
            _isOffline = true;
          });
          _loadUserFromApi();
          return;
        }
      }
    }

    setState(() {
      _loading = true;
      _error = null;
      _isOffline = false;
    });

    try {
      final user = await _api.getUser(widget.username);
      await _storage.saveUserDetail(widget.username, user);
      setState(() {
        _user = user;
        _loading = false;
        _isOffline = false;
      });
    } catch (e) {
      final cached = await _storage.getUserDetail(widget.username);
      if (cached != null) {
        setState(() {
          _user = cached;
          _loading = false;
          _isOffline = true;
          _error = null;
        });
        return;
      }

      final allUsers = await _storage.getUsers();
      if (allUsers != null) {
        final userFromList = allUsers.firstWhere(
          (u) => u.login == widget.username,
          orElse: () => User(login: '', id: 0),
        );
        if (userFromList.login == widget.username) {
          setState(() {
            _user = userFromList;
            _loading = false;
            _isOffline = true;
            _error = null;
          });
          return;
        }
      }

      setState(() {
        _error = 'No internet connection and no cached data available';
        _loading = false;
      });
    }
  }

  Future<void> _loadUserFromApi() async {
    try {
      final user = await _api.getUser(widget.username);
      await _storage.saveUserDetail(widget.username, user);
      if (mounted) {
        setState(() {
          _user = user;
          _isOffline = false;
        });
      }
    } catch (e) {}
  }

  Future<void> _loadRepos({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _storage.getUserRepos(widget.username);
      if (cached != null && cached.isNotEmpty) {
        setState(() {
          _repos = cached;
        });
        _loadReposFromApi();
        return;
      }
    }

    setState(() {
      _loadingRepos = true;
    });

    try {
      final repos = await _api.getRepos(widget.username);
      await _storage.saveUserRepos(widget.username, repos);
      setState(() {
        _repos = repos;
        _loadingRepos = false;
      });
    } catch (e) {
      final cached = await _storage.getUserRepos(widget.username);
      if (cached != null && cached.isNotEmpty) {
        setState(() {
          _repos = cached;
          _loadingRepos = false;
        });
      } else {
        setState(() {
          _loadingRepos = false;
        });
      }
    }
  }

  Future<void> _loadReposFromApi() async {
    try {
      final repos = await _api.getRepos(widget.username);
      await _storage.saveUserRepos(widget.username, repos);
      if (mounted) {
        setState(() {
          _repos = repos;
        });
      }
    } catch (e) {}
  }

  Color _getLanguageColor(String language) {
    switch (language) {
      case 'Dart':
        return Colors.blue;
      case 'JavaScript':
        return Colors.yellow;
      case 'TypeScript':
        return Colors.blueAccent;
      case 'Python':
        return Colors.green;
      case 'Java':
        return Colors.orange;
      case 'Kotlin':
        return Colors.purple;
      case 'Swift':
        return Colors.red;
      case 'Go':
        return Colors.cyan;
      case 'Rust':
        return Colors.orange;
      case 'C++':
        return Colors.blueGrey;
      case 'C':
        return Colors.grey;
      case 'Ruby':
        return Colors.red;
      case 'PHP':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.username)),
      body: _loading && _user == null
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _user == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No Internet Connection',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        _loadUser(forceRefresh: true);
                        _loadRepos(forceRefresh: true);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          : _user == null
          ? const Center(child: Text('No data'))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isOffline)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      color: Colors.orange.withOpacity(0.1),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Showing offline data',
                            style: TextStyle(
                              color: Colors.orange[900],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _user!.avatarUrl != null
                              ? NetworkImage(_user!.avatarUrl!)
                              : null,
                          child: _user!.avatarUrl == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _user!.name ?? _user!.login,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('@${_user!.login}'),
                              if (_user!.bio != null && _user!.bio!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(_user!.bio!),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${_user!.followers ?? 0}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text('Followers'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '${_user!.following ?? 0}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text('Following'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '${_user!.publicRepos ?? 0}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text('Repos'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Repositories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _loadingRepos && _repos.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : _repos.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: Text('No repositories')),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _repos.length,
                          itemBuilder: (context, index) {
                            final repo = _repos[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      repo.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (repo.description != null &&
                                        repo.description!.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        repo.description!,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        if (repo.language != null) ...[
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: _getLanguageColor(
                                                repo.language!,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            repo.language!,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                        ],
                                        const Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${repo.stars}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        const Icon(
                                          Icons.call_split,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${repo.forks}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
