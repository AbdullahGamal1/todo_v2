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
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  int currentIndex = 0;
  var isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  List<Widget> screens = [NewTasksScreen(), DoneTasks(), Archive()];
  List<String> titlesNames = ['New Tasks', ' Done Tasks ', 'Archive'];

  void changeIndex(index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDataBase() {
    openDatabase(
      'todo.db', //path is required
      version: 1,
      onCreate: (dataBase, version) {
        print('database created');
        dataBase
            .execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT, date TEXT, time TEXT,  status TEXT)',
        )
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
        'INSERT INTO  tasks(title ,  date , time , status) VALUES ("$title" ,"$date" ,"$time" ," new" )',
      )
          .then((value) {
        print('$value inserted successfully ^_^');
        emit(AppInsertDataBaseState());
        getFromDataBase(dataBase);
      }).catchError((onError) {
        print('error when data insert *_* ${onError.toString()}');
      });
    });
  }

  void getFromDataBase(dataBase) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDataBaseLoadingState());
    dataBase.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == ' new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(AppGetDataBaseState());
    });
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void updateDataBase({required String status, required int id}) async {
    await dataBase?.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getFromDataBase(dataBase);
      emit(AppUpdateDataBaseState());
    });
  }

  void deleteFromDataBase({required int id}) async {
    await dataBase
        ?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getFromDataBase(dataBase);
      emit(AppDeleteDataBaseState());
    });
  }
}
