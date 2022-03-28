import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/layout/todo_cubit/todo_cubit.dart';
import 'package:todo/layout/todo_cubit/todo_sates.dart';
import 'package:todo/shared/component/component.dart';

class TodoLayout extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController= TextEditingController();
  var timeController= TextEditingController();
  var dateController= TextEditingController();
  Database? database;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>TodoCubit()..createDataBase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state){
          if(state is TodoInsertDatabaseSuccessState)
            {
              Navigator.pop(context);
            }
        },
        builder: (context, state){
          var cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! TodoGetDatabaseLoadingState,
              builder: (context)=>cubit.screens[cubit.currentIndex],
              fallback: (context)=>const Center(child: CircularProgressIndicator(),),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(cubit.isBottomSheetShown)
                {
                  if(formKey.currentState!.validate())
                  {
                    cubit.insertToDataBase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text
                    );
                  }
                }
                else{
                  scaffoldKey.currentState!.showBottomSheet((context) =>
                      Container(
                        color: Colors.white,
                        padding:const  EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children:
                            [
                              defaultTextFormField(
                                  controller: titleController,
                                  validator: (value){
                                    if(value!.isEmpty)
                                    {
                                      return 'Title must be not empty';
                                    }
                                    return null;
                                  },
                                  inputType: TextInputType.text,
                                  label: 'Task Title',
                                  prefix: Icons.title_outlined
                              ),
                              const SizedBox(height: 10.0),
                              defaultTextFormField(
                                  controller: timeController,
                                  validator: (value){
                                    if(value!.isEmpty)
                                    {
                                      return 'Time must be not empty';
                                    }
                                    return null;
                                  },
                                  onTap: ()
                                  {
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now()
                                    ).then((value) {
                                      timeController.text = value!.format(context).toString();
                                      print(value.format(context).toString());
                                    });
                                  },
                                  inputType: TextInputType.text,
                                  label: 'Task Time',
                                  prefix: Icons.watch_later_outlined
                              ),
                              const SizedBox(height: 10.0),
                              defaultTextFormField(
                                  controller: dateController,
                                  validator: (value){
                                    if(value!.isEmpty)
                                    {
                                      return 'Date must be not empty';
                                    }
                                    return null;
                                  },
                                  onTap: ()
                                  {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-05-01'),
                                    ).then((value) {
                                      dateController.text = DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  inputType: TextInputType.text,
                                  label: 'Task Date',
                                  prefix: Icons.calendar_today_outlined
                              ),
                            ],
                          ),
                        ),
                      ),
                    elevation: 20.0,
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(
                        isShown: false,
                        icon: Icons.edit
                    );
                  });
                  cubit.changeBottomSheetState(
                      isShown: true,
                      icon: Icons.add
                  );
                }
              },
              child:  cubit.fabIcon,
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 20.0,
              currentIndex: cubit.currentIndex,
              onTap: (index)
              {
                cubit.changeBottomNavBarIndex(index);
              },
              items:cubit.items,
            ),
          );
        },
      ),
    );
  }
}

