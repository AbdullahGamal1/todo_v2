import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_v2/shared/cubit/cubit.dart';

typedef Myvalidator = String? Function(String);
typedef MyOnTap = Function();
typedef MyOnChange = Function();
typedef MyOnSubmit = Function();

Widget DefaultFormField(
        {required TextEditingController controller,
        required TextInputType type,
        MyOnSubmit? onSubmit,
        MyOnTap? onTap,
        MyOnChange? onChange,
        Myvalidator? validate,
        required String? label,
        required IconData? prefixIcon,
        IconData? safixIcon,
        bool isClickable = true}) =>
    TextFormField(
      decoration: InputDecoration(
          labelText: label,
          enabled: isClickable,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: Icon(safixIcon),
          border: OutlineInputBorder()),
      controller: controller,
      keyboardType: type,
      onChanged: (value) {
        onChange!();
      },
      onTap: () {
        onTap!();
      },
      onFieldSubmitted: (value) {
        onSubmit!();
      },
      validator: (value) {
        return validate!(value!);
      },
    );

Widget BuildTaskitem(Map model, context) => Dismissible(
      onDismissed: (direction) =>
          AppCubit.get(context).deleteFromDataBase(id: model['id']),
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${model['time']}'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${model['title']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${model['date']}',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(width: 10),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateDataBase(status: 'done', id: model['id']);
                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.greenAccent,
                )),
            SizedBox(width: 10),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateDataBase(status: 'archive', id: model['id']);
                },
                icon: Icon(Icons.archive, color: Colors.grey))
          ],
        ),
      ),
    );
Widget tasksBuilder({required List<Map> tasks}) => ConditionalBuilder(
    condition: tasks.length > 0,
    builder: (context) => ListView.separated(
        itemBuilder: (context, index) => BuildTaskitem(tasks[index], context),
        separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
        itemCount: tasks.length),
    fallback: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu,
                size: 100,
                color: Colors.grey,
              ),
              Text(
                'No Tasks Yet ,Please Add Some Tasks ',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              )
            ],
          ),
        ));
