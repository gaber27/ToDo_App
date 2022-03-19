import 'dart:core';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/cubit/cubit.dart';
import 'package:todoapp/cubit/state.dart';
import 'package:todoapp/shared/components.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatebase(),
      child:
      BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {
          if(state is AppInsertDateBaseState)
          {
            Navigator.pop(context);
          }

        },
        builder: (BuildContext context, state) {
          AppCubit cubit = AppCubit.get(context);

          return
            Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text
                  (
                    cubit.titles[cubit.currentIndex]
                ),
              ),
              body:
              ConditionalBuilder(
                condition: state is! AppGetDateBaseLoadinState,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
              floatingActionButton:
              FloatingActionButton(
                onPressed: () async
                {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatebase
                        (
                          title: titleController.text,
                          date: dateController.text,
                          time: timeController.text,
                      );
                    }
                  } else {
                    scaffoldKey.currentState!.showBottomSheet(
                          (context) =>
                          Container(
                            color: Colors.grey[100],
                            padding: EdgeInsets.all(5),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormFiled(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    Validate: (String ?value) {
                                      if (value!.isEmpty) {
                                        return 'Time must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task title',
                                    Prefix: Icons.title,
                                  ),

                                  SizedBox
                                    (
                                    height: 10.0,
                                  ),

                                  defaultFormFiled(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now()
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                        print((value.format(context)));
                                      });
                                    },
                                    Validate: (String ?value) {
                                      if (value!.isEmpty) {
                                        return 'Time must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task time',
                                    Prefix: Icons.watch_later_outlined,
                                  ),

                                  SizedBox
                                    (
                                    height: 10.0,
                                  ),
                                  defaultFormFiled(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    label: 'Task Date',
                                    Prefix: Icons.calendar_today,
                                    Validate: (String ?value) {
                                      if (value!.isEmpty) {
                                        return 'date must not be empty';
                                      }
                                      return null;
                                    },

                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2022-05-03'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      elevation: 20.0,
                    ).closed.then((value) {
                      cubit.ChangeBottomSheetStates(isShow: false, icon: Icons.edit,);
                    }
                    );
                    cubit.ChangeBottomSheetStates(isShow: true, icon: Icons.add,);
                  }

                },
                child: Icon(
                cubit.fabIcon,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: AppCubit
                    .get(context)
                    .currentIndex,
                onTap: (index) {
                  AppCubit.get(context).changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon:
                      Icon(Icons.menu),
                      label: 'Tasks'
                  ),
                  BottomNavigationBarItem(
                      icon:
                      Icon(Icons.check_circle_outline),
                      label: 'Done'
                  ),
                  BottomNavigationBarItem(
                      icon:
                      Icon(Icons.archive_outlined),
                      label: 'Arcaived'
                  ),

                ],
              ),
            );
        },
      ),
    );
  }
}
