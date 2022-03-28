import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/layout/todo_layout.dart';
import 'package:todo/shared/bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(()
  {
    runApp(const MyApp());
  },
    blocObserver: MyBlocObserver(),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: TodoLayout(),
    );
  }
}

