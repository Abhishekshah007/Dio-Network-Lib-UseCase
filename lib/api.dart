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
// Initializing empty list of users
  late List<User> _users;

  @override
  void initState() {
    super.initState();
// Initializing users list as empty
    _users = [];
// Fetching users from API
    _fetchUsers();
  }

// Fetch users from API and update the state
  Future<void> _fetchUsers() async {
    try {
// Sending GET request to API
      final response = await Dio().get('https://reqres.in/api/users?page=1');
// Extracting data from response
      final data = response.data['data'] as List<dynamic>;
// Converting data into List of User objects
      final users = data.map((e) => User.fromJson(e)).toList();
// Updating state with users list
      setState(() {
        _users = users;
      });
    } catch (e) {
// Printing error to console if running in debug mode
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _users.isNotEmpty // Checking if users list is not empty
          ? ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
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
            )
          : const Center(
              child:Card(
                color: Colors.amber,
                child: Text('Loding...error..network..err..r'),
              )

      ), // Showing progress indicator if users list is empty
    );
  }
}
