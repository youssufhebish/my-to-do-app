import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/states.dart';

Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  Function onTap,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validate,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        border: OutlineInputBorder(),
      ),
    );

Widget taskItem(Map model, context) =>
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Dismissible(
        key: Key(model['id'].toString()),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(model['time']),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    model['title'],
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    model['date'],
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.check_box,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      AppCubit.get(context).updateDataBase(status: 'done', id: model['id']);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.archive,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      AppCubit.get(context).updateDataBase(status: 'archive', id: model['id']);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        onDismissed: (direction){
          AppCubit.get(context).deleteDataBase(id: model['id']);
        },
      ),
    );

Widget svgMessage() =>
    Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          SvgPicture.asset(
            'assets/SVG/inbox.svg',
            width: 125.0,
            height: 125.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'EMPTY',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
        ),
      
    );