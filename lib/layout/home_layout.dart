import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_v2/shared/componat/componats/componants.dart';
import 'package:todo_v2/shared/cubit/cubit.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title:
                  Text(AppCubit.get(context).titlesNames[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataBaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDataBase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
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
                                          onSubmit: () {},
                                          validate: (value) {
                                            if (value.trim().isEmpty) {
                                              return "Please Enter Task Name";
                                            }
                                            return null;
                                          },
                                          label: "Task Title ",
                                          prefixIcon: Icons.title),
                                      SizedBox(height: 15),
                                      DefaultFormField(
                                        controller: dateController,
                                        type: TextInputType.datetime,
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2025-01-01'),
                                          ).then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                            print(dateController);
                                          });
                                        },
                                        validate: (value) {
                                          if (value.trim().isEmpty) {
                                            return "Please Enter The Date";
                                          }
                                          return null;
                                        },
                                        label: "Date Of Task ",
                                        prefixIcon:
                                            Icons.calendar_month_rounded,
                                      ),
                                      SizedBox(height: 15),
                                      DefaultFormField(
                                        controller: timeController,
                                        type: TextInputType.datetime,
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            timeController.text =
                                                value!.format(context);
                                            print('${value.format(context)}');
                                          });
                                        },
                                        validate: (value) {
                                          if (value.trim().isEmpty) {
                                            return "Please Enter Time";
                                          }
                                          return null;
                                        },
                                        label: "Task Time ",
                                        prefixIcon: Icons.watch_later_outlined,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 25)
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: 'Archive'),
              ],
            ),
          );
        },
      ),
    );
  }
}
