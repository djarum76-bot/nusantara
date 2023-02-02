import 'package:dio/dio.dart';
import 'package:nusantara/utils/contants.dart';

class InternetService{
  static Dio dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseURL,
        connectTimeout: 60000,
        receiveTimeout: 60000,
      )
  );
}