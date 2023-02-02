import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusantara/models/book_model.dart';
import 'package:nusantara/repositories/book_repository.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository bookRepository;

  BookBloc({required this.bookRepository}) : super(const BookState()) {
    on<BookFetched>(
      _onBookFetched
    );
    on<BooksFetched>(
        _onBooksFetched
    );
    on<BookAdded>(
        _onBookAdded
    );
    on<BookDeleted>(
        _onBookDeleted
    );
    on<BookEdited>(
        _onBookEdited
    );
  }

  Future<void> _onBookAdded(BookAdded event, Emitter<BookState> emit)async{
    emit(state.copyWith(status: BookStatus.loading));
    try{
      await bookRepository.addBook(event.book);
      final books = await bookRepository.getAllBooks();
      emit(state.copyWith(
        status: BookStatus.added,
        books: books
      ));
    }catch(e){
      emit(state.copyWith(
        status: BookStatus.error,
        message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onBookDeleted(BookDeleted event, Emitter<BookState> emit)async{
    emit(state.copyWith(status: BookStatus.loading));
    try{
      await bookRepository.deleteBook(event.id);
      final books = await bookRepository.getAllBooks();
      emit(state.copyWith(
          status: BookStatus.deleted,
          books: books
      ));
    }catch(e){
      emit(state.copyWith(
          status: BookStatus.error,
          message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onBookEdited(BookEdited event, Emitter<BookState> emit)async{
    emit(state.copyWith(status: BookStatus.loading));
    try{
      await bookRepository.editBook(event.book);
      final book = await bookRepository.getBook(event.book.id!);
      final books = await bookRepository.getAllBooks();
      emit(state.copyWith(
          status: BookStatus.edited,
          books: books,
          book: book,
      ));
    }catch(e){
      emit(state.copyWith(
          status: BookStatus.error,
          message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onBooksFetched(BooksFetched event, Emitter<BookState> emit)async{
    emit(state.copyWith(status: BookStatus.loading));
    try{
      final books = await bookRepository.getAllBooks();
      emit(state.copyWith(
          status: BookStatus.fetched,
          books: books
      ));
    }catch(e){
      emit(state.copyWith(
          status: BookStatus.error,
          message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onBookFetched(BookFetched event, Emitter<BookState> emit)async{
    emit(state.copyWith(status: BookStatus.loading));
    try{
      final book = await bookRepository.getBook(event.id);
      emit(state.copyWith(
          status: BookStatus.fetched,
          book: book
      ));
    }catch(e){
      emit(state.copyWith(
          status: BookStatus.error,
          message: e.toString()
      ));
      throw Exception(e);
    }
  }
}
