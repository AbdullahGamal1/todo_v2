import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_v2/modules/tasks/done_task.dart';
import 'package:todo_v2/modules/tasks/new_tasks_screen.dart';

import '../../modules/tasks/archive.dart';

part 'state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  Database? dataBase;
  List<Map> tasks = [];
  int currentIndex = 0;
  List<Widget> screens = [NewTasksScreen(), DoneTasks(), Archive()];
  List<String> titlesNames = ['New Tasks', ' Done Tasks ', 'Archive'];

  void changeindex(index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDataBase() {
    openDatabase(
      'todo.db', //path is required
      version: 1,
      onCreate: (dataBase, version) {
        print('database created');
// id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL
        dataBase
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT, date TEXT, time TEXT,  status TEXT)')
            .then((value) {
          print('table created ');
        }).catchError((error) {
          print('Error when table created ${error.toString()}');
        });
      },
      onOpen: (dataBase) {
        getFromDataBase(dataBase).then((value) {
          tasks = value;
          print(tasks);
          emit(AppGetDataBaseState());
        });
        print('database opened');
      },
    ).then((value) {
      dataBase = value;
      emit(AppCreateDataBaseState());
    });
  }

  Future insertToDataBase({
    required String title,
    required String time,
    required String date,
  }) async {
    await dataBase?.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO  tasks(title ,  date , time , status) VALUES ("$title" ,"$date" ,"$time" ," new" )')
          .then((value) {
        print('$value inserted successfully ^_^');
        emit(AppInsertDataBaseState());
        getFromDataBase(dataBase).then((value) {
          tasks = value;
          print(tasks);
          emit(AppGetDataBaseState());
        });
      }).catchError((onError) {
        print('error when data insert *_* ${onError.toString()}');
      });
    });
  }

  Future<List<Map>> getFromDataBase(dataBase) async {
    emit(AppGetDataBaseLoadingState());
    tasks = await dataBase.rawQuery('SELECT * FROM tasks');
    //   // يتم التحقق من عدم فراغ قائمة Map
    // assert(tasks.isNotEmpty, 'No tasks found in the database');
    print(tasks);
    return tasks;
  }

  var isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void updateDataBase() {}
}
