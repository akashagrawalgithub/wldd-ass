import 'package:flutter/material.dart';
import '../services/github_api.dart';
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
  User? _user;
  List<Repo> _repos = [];
  bool _loading = false;
  bool _loadingRepos = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadRepos();
  }

  Future<void> _loadUser() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = await _api.getUser(widget.username);
      setState(() {
        _user = user;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _loadRepos() async {
    setState(() {
      _loadingRepos = true;
    });

    try {
      final repos = await _api.getRepos(widget.username);
      setState(() {
        _repos = repos;
        _loadingRepos = false;
      });
    } catch (e) {
      setState(() {
        _loadingRepos = false;
      });
    }
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : _user == null
          ? const Center(child: Text('No data'))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  _loadingRepos
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
