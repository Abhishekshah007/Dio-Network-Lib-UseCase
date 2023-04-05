// Importing necessary libraries
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// User class to store user details
class User {
  final String image;
  final String email;
  final String firstName;
  final String lastName;

  User({
    required this.image,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

// Factory method to convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      image: json['avatar'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}

// Stateful widget to fetch user list and display them
class FetchUserList extends StatefulWidget {
  const FetchUserList({Key? key}) : super(key: key);

  @override
  State<FetchUserList> createState() => FetchUserListState();
}

class FetchUserListState extends State<FetchUserList> {
  late List<User> _users;
  int _currentPage = 1; // track current page number

  @override
  void initState() {
    super.initState();
    _users = [];
    _fetchUsers(_currentPage); // initial fetch with page 1
  }

  Future<void> _fetchUsers(int page) async {
    try {
      final response = await Dio().get('https://reqres.in/api/users?page=$page');
      final data = response.data['data'] as List<dynamic>;
      final users = data.map((e) => User.fromJson(e)).toList();
      setState(() {
        _users.addAll(users); // add fetched users to existing list
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _loadMoreUsers() async {
    setState(() {
      _currentPage++; // increment current page number
    });
    await _fetchUsers(_currentPage); // fetch users for new page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _users.isNotEmpty
          ? NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            final maxScroll = notification.metrics.maxScrollExtent;
            final currentScroll = notification.metrics.pixels;
            final delta = MediaQuery.of(context).size.height * 0.20; // 20% of screen height
            if (maxScroll - currentScroll <= delta) {
              _loadMoreUsers(); // load more users when scroll reaches end
            }
          }
          return true;
        },
        child: ListView.builder(
          itemCount: _users.length + 1, // add one for loading indicator
          itemBuilder: (context, index) {
            if (index == _users.length) { // show loading indicator at end of list
              return const Center(child: CircularProgressIndicator());
            }
            final user = _users[index];
            return Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.blueGrey,
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.network(
                      user.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.lightBlue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}