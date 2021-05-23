import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/components/components.dart';
import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatefulWidget {
  @override
  _NewTasksScreenState createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<ArchivedTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) => null,
      builder: (context, state) =>
          ConditionalBuilder(
              condition: AppCubit.get(context).archivedTasks.length > 0,
              builder: (context) => ListView.separated(
                  itemBuilder: (context, index) => taskItem(
                      AppCubit.get(context).archivedTasks[index], context),
                  separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: 20.0,
                          end: 20.0,
                        ),
                        child: Divider(),
                      ),
                  itemCount: AppCubit.get(context).archivedTasks.length),
              fallback: (context) => svgMessage(),
            ),);
  }
}
