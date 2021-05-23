import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do/shared/components/constants.dart';
import 'package:to_do/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isBottomSheet = false;
  IconData fabicon = Icons.add;

  int currentIndex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppBottomNavBarState());
  }

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];


  Database database;

  void createDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');

        database
            .execute(
                "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)")
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('${error.toString()}');
        });
      },
      onOpen: (database) {
        getData(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDB());
    });
  }

  Future insertDataBase({
    @required String title,
    @required String date,
    @required String time,
  }) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print("$value inserted successfully");
        emit(AppInsertDB());

        getData(database);

      }).catchError((e) {
        print("an error");
      });
      return null;
    });
  }

  void updateDataBase({
    @required String status,
    @required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          getData(database);
      emit(AppUpdateDB());
    });
  }

  void deleteDataBase({
    @required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getData(database);
      emit(AppDeleteDB());
    });
  }

  Future<List<Map>> getData(database) async {

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    return await database.rawQuery('SELECT * FROM tasks').then((value) {
      print(value);
      value.forEach((e){
        if(e['status'] == 'new') newTasks.add(e);
        else if(e['status'] == 'done') doneTasks.add(e);
        else if(e['status'] == 'archive') archivedTasks.add(e);
      });
      emit(AppGetDB());
      changeBottomSheet(isShown: false, icon: Icons.edit);
    });
  }

  void changeBottomSheet({
    @required bool isShown,
    @required IconData icon,
  }) {
    isBottomSheet = isShown;
    fabicon = icon;

    emit(AppChangeBottomSheet());
  }


}
