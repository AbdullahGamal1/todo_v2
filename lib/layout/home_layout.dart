import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_v2/componat/componats/componants.dart';
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
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    creatDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titlesNames[currentIndex]),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDataBase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text)
                  .then((value) {
                Navigator.pop(context);
                isBottomSheetShown = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              });
            }
          } else {
            scaffoldKey.currentState
                ?.showBottomSheet(
                    (context) => Container(
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DefaultFormField(
                                    onTap: () {},
                                    controller: titleController,
                                    type: TextInputType.text,
                                    onChange: () {},
                                    validate: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Please Enter Task Name";
                                      }
                                    },
                                    label: "Task Title ",
                                    prefixIcon: Icons.title),
                                SizedBox(height: 15),
                                DefaultFormField(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context);
                                        print('${value.format(context)}');
                                      });
                                    },
                                    validate: (value) {
                                      if (value.trim().isEmpty) {
                                        return "Please Enter Time";
                                      }
                                    },
                                    label: "Task Time ",
                                    prefixIcon: Icons.watch_later_outlined),
                                SizedBox(height: 15),
                                DefaultFormField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2025-01-01'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                        print(dateController);
                                      });
                                    },
                                    validate: (value) {
                                      if (value.trim().isEmpty) {
                                        return "Please Enter The Date";
                                      }
                                    },
                                    label: "Date Of Task ",
                                    prefixIcon: Icons.calendar_month_rounded)
                              ],
                            ),
                          ),
                        ),
                    elevation: 25)
                .closed
                .then((value) {
              isBottomSheetShown = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            });
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
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
        getFromDataBase(dataBase);
        print('database opened');
      },
    );
  }

  Future insertToDataBase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await dataBase?.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO  tasks(title ,  date , time , status) VALUES ("$title" ,"$date" ,"$time" ," new" )')
          .then((value) {
        print('$value inserted successfully ^_^');
      }).catchError((onError) {
        print('error when data insert *_* ${onError.toString()}');
      });
    });
  }

  Future<List<Map>> getFromDataBase(dataBase) async {
    List<Map> tasks = await dataBase.rawQuery('SELECT * FROM tasks');
    //   // يتم التحقق من عدم فراغ قائمة Map
    assert(tasks.isNotEmpty, 'No tasks found in the database');
    print(tasks);
    return tasks;
  }

  void updateDataBase() {}
}
