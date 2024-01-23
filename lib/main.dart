import 'dart:io';

import 'package:async_cache_exam/api/api_service.dart';
import 'package:async_cache_exam/data/todo_repository.dart';
import 'package:async_cache_exam/model/todo.dart';
import 'package:async_cache_exam/todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter());
  await Hive.openBox<ToDo>('todoBox_test');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ToDoScreen(
        repository: ToDoRepository(
          ApiService(
            Dio(),
            baseUrl: Platform.isAndroid
                ? 'http://10.0.2.2:3000'
                : 'http://localhost:3000',
          ),
          Hive.box<ToDo>('todoBox_test'),
        ),
      ),
    );
  }
}
