import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/cubit/state.dart';
import 'package:todoapp/todo_app/archaivedtask/archaived_task_screen.dart';
import 'package:todoapp/todo_app/donetasks/done_task_screen.dart';
import 'package:todoapp/todo_app/newtasks/new_tasks_screen.dart';
class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());
  //باخد object مني
  static AppCubit get(Context)=> BlocProvider.of(Context);
  late Database database;
  int currentIndex=0;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];
  List<Widget> screens =
  [
    new_tasks_screen(),
    done_tasks_screen(),
    archaived_tasks_screen()
  ];
  List<String> titles=
  [
    'New Tasks',
    'Done Tasks',
    'Archaived Tasks',
  ];
  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavabBarState());

  }
  void createDatebase()
  {
    openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database, version)
        {
          print('DataBase Created');
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT , date TEXT, time TEXT, status TEXT)').then((value)
          {
            print('Table Created');
          }).catchError((error){
            print('Error when creating table ${error.toString()}');
          });
        },
        onOpen: (database)
        {
          getDataFromDatabase(database);
          print('DataBase opened');

        }
    ).then((value) {
      database = value;
      emit(AppCreateDateBaseState());
    });
  }
  insertToDatebase({
    required String title,
    required String date,
    required String time,
  }) async

  {
    await database.transaction((txn) async
    {
      txn.rawInsert('INSERT INTO tasks(title, date , time , status) VALUES("$title","$date","$time","NEW")').then((value)
      {
        print('$value inserted sussafuly');
        emit(AppInsertDateBaseState());

        getDataFromDatabase(database);
      })
          .catchError((error){
        print('Error Inserting Table ${error.toString()}');
      });
    });

  }
  void getDataFromDatabase(database)
  {
    newtasks=[];
    donetasks=[];
    archivedtasks=[];

    emit(AppGetDateBaseLoadinState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element) {
        if(element['status']=='NEW')
          newtasks.add(element);
        else if(element['status']=='done')
          donetasks.add(element);
        else archivedtasks.add(element);
      }
      );
      emit(AppGetDateBaseState());
    });

  }

  void updateData({
    required String status,
    required int id,
  }) async
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppUpdateDateBaseLoadinState());

    }
    );

  }
  void deleteDate({
    required id
  })
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDateBaseLoadinState());
    });
  }
  }

