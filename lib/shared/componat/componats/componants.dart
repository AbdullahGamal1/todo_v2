import 'package:flutter/material.dart';

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

Widget BuildTaskitem(Map model) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text('${model['time']}'),
          ),
          SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${model['title']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${model['date']}', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
