import 'dart:async';

import 'package:async_cache_exam/api/api_service.dart';
import 'package:async_cache_exam/model/todo.dart';
import 'package:hive_flutter/hive_flutter.dart';

///
/// async_cache_exam
/// File Name: todo_repository
/// Created by sujangmac
///
/// Description:
///

class ToDoRepository {
  final ApiService _apiService;
  final Box<ToDo> _todoBox;
  final _toDosController = StreamController<List<ToDo>>();

  ToDoRepository(this._apiService, this._todoBox) {
    _initialize();
  }

  Stream<List<ToDo>> get toDosStream => _toDosController.stream;

  void _initialize() async {
    // Emit initial data
    _emitCachedData();

    // Fetch new data from API and update stream
    await _fetchAndCacheToDos();
  }

  void _emitCachedData() {
    final cachedToDos = _todoBox.values.toList();
    _toDosController.add(cachedToDos);
  }

  Future<void> _fetchAndCacheToDos() async {
    try {
      final toDos = await _apiService.getToDos();
      for (var toDo in toDos) {
        _todoBox.put(toDo.id, toDo);
      }
      _emitCachedData();
    } catch (e) {
      print('Error fetching ToDos: $e');
    }
  }

  Future<void> createToDo(String text) async {
    try {
      final newToDo = await _apiService.createToDo(ToDo(id: '', text: text));
      await _todoBox.put(newToDo.id, newToDo);
      _emitCachedData();
    } catch (e) {
      print('Error creating ToDo: $e');
    }
  }

  Future<void> updateToDo(String id) async {
    try {
      final updatedToDo = await _apiService.updateToDo(id);
      await _todoBox.put(id, updatedToDo);
      _emitCachedData();
    } catch (e) {
      print('Error updating ToDo: $e');
    }
  }

  Future<void> refreshToDos() async {
    await _fetchAndCacheToDos();
  }

  void dispose() {
    _toDosController.close();
  }
}
