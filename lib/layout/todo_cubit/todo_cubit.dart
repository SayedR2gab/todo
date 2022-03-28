import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/layout/todo_cubit/todo_sates.dart';
import 'package:todo/modules/archived_tasks/archived_tasks.dart';
import 'package:todo/modules/done_tasks/done_tasks.dart';
import 'package:todo/modules/new_tasks/new_tasks.dart';

class TodoCubit extends Cubit<TodoStates>
{
  TodoCubit(): super(TodoInitState());
  static TodoCubit get(context)=>BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];
  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
        icon: Icon(Icons.menu),
        label: 'Tasks'
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.check_circle_outline),
        label: 'Done Tasks'
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.archive_outlined),
        label: 'Archived Tasks'
    ),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void changeBottomNavBarIndex(index)
  {
    currentIndex = index;
    emit(TodoChangeBottomNavBarState());
  }


  Database? database;
  List<Map>? newTasks= [];
  List<Map>? doneTasks= [];
  List<Map>? archivedTasks= [];
  //create database
  void createDataBase() {
    openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database,version){
          print('database created');
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value) {
            print('tables created');
          }).catchError((error){
            print('error: ${error.toString()}');
          });
        },
        onOpen: (database)
        {
          getDataFromDatabase(database);
          print('database opened');
        }
    ).then((value) {
      database = value;
      emit(TodoCreateDatabaseSuccessState());
    });
  }
  //insert to database
  Future insertToDataBase({
    required String title,
    required String time,
    required String date,
  })async{
    return await database!.transaction((txn)  => txn.rawInsert('INSERT INTO tasks (title,date,time,status) VALUES ("$title","$date","$time","new")')
        .then((value) {
          emit(TodoInsertDatabaseSuccessState());
          getDataFromDatabase(database);
      print(' $value Insert Successfully');
    }).catchError((error){
      print('error ${error.toString()}');
    }));
  }

  //get data from database
  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks= [];
    archivedTasks= [];
    emit(TodoGetDatabaseLoadingState());
   database!.rawQuery('SELECT * FROM tasks').then((value) {
     value.forEach((element) {
       if(element['status'] == 'new') {
         newTasks!.add(element);
       }
       else if(element['status'] == 'done') {
         doneTasks!.add(element);
       }
       else if(element['status'] == 'archived') {
         archivedTasks!.add(element);
       }
     });
     emit(TodoGetDatabaseSuccessState());
   });

  }

  void updateDatabase({
  required String status,
  required int id,
})async
  {
     await database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]).then((value) {
          getDataFromDatabase(database);
       emit(TodoUpdateDatabaseSuccessState());
     });
  }

  void deleteDatabase({
  required int id
})
  {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(TodoDeleteDatabaseSuccessState());
    });
  }

  bool isBottomSheetShown = false;
  Icon fabIcon = const Icon(Icons.add) ;
  void changeBottomSheetState({
  required bool isShown,
    required IconData icon,
}){
    isBottomSheetShown = isShown;
    fabIcon = Icon(icon);
    emit(TodoChangeBottomSheetState());
  }
}