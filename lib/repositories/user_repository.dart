import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nusantara/models/user_model.dart';
import 'package:nusantara/services/internet_service.dart';
import 'package:nusantara/services/storage_service.dart';
import 'package:nusantara/utils/contants.dart';

class UserRepository{
  Future<void> register(String name, String email, String password, String passwordConfirmation)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.name : name,
        Constants.email : email,
        Constants.password : password,
        Constants.passwordConfirmation : passwordConfirmation,
      });

      await InternetService.dio.post('/api/register',
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.acceptHeader : Constants.appJson,
            HttpHeaders.contentTypeHeader : Constants.appJson,
          }
        )
      );
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> login(String email, String password)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.email : email,
        Constants.password : password
      });

      final response = await InternetService.dio.post('/api/login',
          data: formData,
          options: Options(
              headers: {
                HttpHeaders.acceptHeader : Constants.appJson,
                HttpHeaders.contentTypeHeader : Constants.appJson,
              }
          )
      );

      if(response.statusCode == 200){
        await StorageService.box.write(Constants.token, response.data[Constants.token]);
        await StorageService.box.write(Constants.isAutoLogin, true);
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> logout()async{
    try{
      final response = await InternetService.dio.delete('/api/user/logout',
          options: Options(
              headers: {
                HttpHeaders.acceptHeader : Constants.appJson,
                HttpHeaders.contentTypeHeader : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );

      if(response.statusCode == 200){
        await StorageService.box.remove(Constants.token);
        await StorageService.box.remove(Constants.isAutoLogin);
        await StorageService.box.erase();
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<UserModel> getUser()async{
    try{
      final response = await InternetService.dio.get('/api/user',
          options: Options(
              headers: {
                HttpHeaders.acceptHeader : Constants.appJson,
                HttpHeaders.contentTypeHeader : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );

      if(response.statusCode == 200){
        return UserModel.fromJson(response.data);
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }
}