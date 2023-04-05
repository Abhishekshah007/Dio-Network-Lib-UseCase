// import necessary packages
import 'package:flutter/material.dart';
import 'package:networking_assignment/api.dart';

// app entry point
void main() {
  runApp(const MyApp());
}

// root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // material app with a home of MyHome widget
    return const MaterialApp(
      title: "List of users",
      home: MyHome(),
    );
  }
}

// home widget that displays the list of users
class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<StatefulWidget> createState() {
    // returns the state of the widget
    return MyHomeState();
  }
}

// state of MyHome widget
class MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of users"),
      ),
      // fetch and display the list of users using the FetchUserList widget
      body: const FetchUserList(),
    );
  }
}
