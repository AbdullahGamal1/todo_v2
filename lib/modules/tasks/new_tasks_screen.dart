import 'package:flutter/material.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('new tasks',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
