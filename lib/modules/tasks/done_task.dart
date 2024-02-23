import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_v2/shared/componat/componats/componants.dart';
import 'package:todo_v2/shared/cubit/cubit.dart';

class DoneTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).doneTasks;
        return tasksBuilder(tasks: tasks);
      },
    );
  }
}
