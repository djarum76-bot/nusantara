// To parse this JSON data, do
//
//     final bookModel = bookModelFromJson(jsonString);

import 'dart:convert';

import 'package:nusantara/utils/contants.dart';

BookModel bookModelFromJson(String str) => BookModel.fromJson(json.decode(str));

String bookModelToJson(BookModel data) => json.encode(data.toJson());

class BookModel {
  BookModel({
    this.id,
    this.userId,
    this.isbn,
    this.title,
    this.subtitle,
    this.author,
    this.published,
    this.publisher,
    this.pages,
    this.description,
    this.website,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? isbn;
  String? title;
  String? subtitle;
  String? author;
  String? published;
  String? publisher;
  int? pages;
  String? description;
  String? website;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
    id: json["id"],
    userId: json["user_id"],
    isbn: json["isbn"],
    title: json["title"],
    subtitle: json["subtitle"],
    author: json["author"],
    published: json["published"],
    publisher: json["publisher"],
    pages: json["pages"],
    description: json["description"],
    website: json["website"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "isbn": isbn,
    "title": title,
    "subtitle": subtitle,
    "author": author,
    "published": published,
    "publisher": publisher,
    "pages": pages,
    "description": description,
    "website": website,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };

  BookModel.fromMap(Map<String, dynamic> item){
    id = item[Constants.id];
    userId = item[Constants.userId];
    isbn = item[Constants.isbn];
    title = item[Constants.title];
    subtitle = item[Constants.subtitle];
    author = item[Constants.author];
    published = item[Constants.published];
    publisher = item[Constants.publisher];
    pages = item[Constants.pages];
    description = item[Constants.description];
    website = item[Constants.website];
    createdAt = item[Constants.createdAt];
    updatedAt = item[Constants.updatedAt];
  }
}
