import 'package:async_cache_exam/model/todo.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

///
/// async_cache_exam
/// File Name: api_service
/// Created by sujangmac
///
/// Description:
///

part 'api_service.g.dart';

@RestApi(baseUrl: 'http://localhost:3000')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/todo")
  Future<List<ToDo>> getToDos();

  @POST("/todo")
  Future<ToDo> createToDo();

  @PATCH("/todo")
  Future<ToDo> updateToDo(@Path('id') String id);
}
