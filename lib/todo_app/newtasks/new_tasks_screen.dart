import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/cubit/cubit.dart';
import 'package:todoapp/cubit/state.dart';
import 'package:todoapp/shared/components.dart';
class new_tasks_screen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state)
    {
      var tasks = AppCubit.get(context).newtasks;
      return tasksBulider(
        tasks: tasks
      );
    },

    );

  }
}
