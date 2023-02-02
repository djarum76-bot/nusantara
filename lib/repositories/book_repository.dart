import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nusantara/models/book_model.dart';
import 'package:nusantara/services/internet_service.dart';
import 'package:nusantara/services/storage_service.dart';
import 'package:nusantara/utils/contants.dart';

class BookRepository{
  Future<List<BookModel>> getAllBooks()async{
    try{
      final response = await InternetService.dio.get('/api/books',
          options: Options(
              headers: {
                HttpHeaders.acceptHeader : Constants.appJson,
                HttpHeaders.contentTypeHeader : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );

      if(response.statusCode == 200){
        final datas = response.data[Constants.data] as List;
        final list = datas.map((data) => BookModel.fromJson(data)).toList();
        return list;
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<BookModel> getBook(int id)async{
    try{
      final response = await InternetService.dio.get("/api/books/$id",
          options: Options(
              headers: {
                HttpHeaders.acceptHeader : Constants.appJson,
                HttpHeaders.contentTypeHeader : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );

      if(response.statusCode == 200){
        return BookModel.fromJson(response.data);
      }else{
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> addBook(BookModel book)async{
    try{
      FormData formData = FormData.fromMap({
        Constants.isbn : book.isbn,
        Constants.title : book.title,
        Constants.subtitle : book.subtitle,
        Constants.author : book.author,
        Constants.published : book.published,
        Constants.publisher : book.publisher,
        Constants.pages : book.pages,
        Constants.description : book.description,
        Constants.website : book.website,
      });

      await InternetService.dio.post('/api/books/add',
          data: formData,
          options: Options(
              headers: {
                HttpHeaders.acceptHeader : Constants.appJson,
                HttpHeaders.contentTypeHeader : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> editBook(BookModel book)async{
    try{
      var params = {
        Constants.isbn : book.isbn,
        Constants.title : book.title,
        Constants.subtitle : book.subtitle,
        Constants.author : book.author,
        Constants.published : book.published,
        Constants.publisher : book.publisher,
        Constants.pages : book.pages,
        Constants.description : book.description,
        Constants.website : book.website,
      };

      await InternetService.dio.put("/api/books/${book.id}/edit",
          data: jsonEncode(params),
          options: Options(
              headers: {
                HttpHeaders.acceptHeader : Constants.appJson,
                HttpHeaders.contentTypeHeader : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> deleteBook(int id)async{
    try{
      await InternetService.dio.delete("/api/books/$id",
          options: Options(
              headers: {
                HttpHeaders.acceptHeader : Constants.appJson,
                HttpHeaders.contentTypeHeader : Constants.appJson,
                HttpHeaders.authorizationHeader : "${Constants.bearer} ${StorageService.box.read(Constants.token)}"
              }
          )
      );
    }catch(e){
      throw Exception(e);
    }
  }
}