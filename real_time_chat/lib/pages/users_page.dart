import 'package:flutter/material.dart';
import 'package:real_time_chat/models/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late RefreshController _refreshController;
  final bool connected = true;

  final users = <User>[
    User(uid: '1', name: 'Fulano de tal', email: 'fulano@test.com', online: true),
    User(uid: '2', name: 'Fulanito de tal', email: 'fulano@test.com', online: false),
    User(uid: '3', name: 'Fulanote de tal', email: 'fulano@test.com', online: true),
    User(uid: '4', name: 'Fulanototote de tal', email: 'fulano@test.com', online: false),
    User(uid: '5', name: 'Fulaninito de tal', email: 'fulano@test.com', online: false),
  ];

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  Future<void> _loadUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        title: const Text(
          'Mi nombre',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              connected ? Icons.check_circle : Icons.offline_bolt,
              color: connected ? Colors.blue : Colors.red,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _loadUsers,
          header: const WaterDropHeader(
            complete: Text(
              'All updated',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            waterDropColor: Colors.transparent,
            refresh: Text(
              'Consultando...',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            idleIcon: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          ),
          child: _UsersListBuilder(users: users),
        ),
      ),
    );
  }
}

class _UsersListBuilder extends StatelessWidget {
  const _UsersListBuilder({
    Key? key,
    required this.users,
  }) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: users.length,
      separatorBuilder: (_, int index) => const Divider(),
      itemBuilder: (_, int index) {
        final user = users[index];
        return _UserListTile(user: user);
      },
    );
  }
}

class _UserListTile extends StatelessWidget {
  const _UserListTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(user.name.substring(0, 2).toUpperCase()),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: user.online ? Colors.green : Colors.red, borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}
