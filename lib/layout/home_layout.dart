import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_v2/modules/tasks/archive.dart';
import 'package:todo_v2/modules/tasks/done_task.dart';

import '../modules/tasks/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screens = [NewTasksScreen(), DoneTasks(), Archive()];
  List<String> titlesNames = ['New Tasks', ' Done Tasks ', 'Archive'];
  Database? dataBase;

  @override
  void initState() {
    super.initState();
    creatDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titlesNames[currentIndex]),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archive'),
        ],
      ),
    );
  }

  void creatDataBase() async {
    dataBase = await openDatabase(
      'todo.db', //path is required
      version: 1,
      onCreate: (dataBase, version) {
        print('database created');
// id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL
        dataBase
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT, DATE TEXT, time TEXT,  status TEXT)')
            .then((value) {
          print('table created ');
        }).catchError((error) {
          print('Error when table created ${error.toString()}');
        });
      },
      onOpen: (dataBase) {
        print('database opened');
      },
    );
  }

  void insertToDataBase() {
    dataBase?.transaction(
        (txn) => txn.rawInsert('').then((value) {}).catchError((onError) {}));
  }

  void getFromDataBase() {}

  void updateDataBase() {}
}
