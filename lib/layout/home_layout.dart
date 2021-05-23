import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/shared/components/components.dart';
import 'package:to_do/shared/components/constants.dart';
import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/states.dart';


var scaffoldKey = GlobalKey<ScaffoldState>();
var formKey = GlobalKey<FormState>();

TextEditingController titleController = TextEditingController();
TextEditingController timeController = TextEditingController();
TextEditingController dateController = TextEditingController();

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) => {
          if(state is AppInsertDB) Navigator.pop(context)
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fabicon),
              onPressed: () {
                if (cubit.isBottomSheet) {
                  if (formKey.currentState.validate()) {
                    cubit.insertDataBase(title: titleController.text, date: dateController.text, time: timeController.text);
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet(
                        (context) => Container(
                      padding: EdgeInsets.all(20.0),
                      color: Colors.grey[100],
                      width: double.infinity,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              child: defaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'title must not to be empty';
                                    }
                                    return null;
                                  },
                                  label: 'task',
                                  prefix: Icons.title),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              child: defaultFormField(
                                  onTap: () {
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text = value
                                          .format(context)
                                          .toString()
                                          .toUpperCase();
                                    });
                                  },
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'time must not to be empty';
                                    }
                                    return null;
                                  },
                                  label: 'time',
                                  prefix: Icons.watch),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              child: defaultFormField(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2021-06-06'),
                                    ).then((value) {
                                      print('${value.toString()}');
                                      dateController.text =
                                          DateFormat.yMMMd().format(value);
                                    });
                                  },
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'date must not to be empty';
                                    }
                                    return null;
                                  },
                                  label: 'date',
                                  prefix: Icons.calendar_today),
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(isShown: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheet(isShown: true, icon: Icons.add);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_open),
                  label: 'tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done),
                  label: 'done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'archived',
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

