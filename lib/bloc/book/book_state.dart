part of 'book_bloc.dart';

enum BookStatus { initial, loading, error, fetched, added, edited, deleted }

class BookState extends Equatable{
  const BookState({
    this.status = BookStatus.initial,
    this.books = const <BookModel>[],
    this.book,
    this.message
  });

  final BookStatus status;
  final List<BookModel> books;
  final BookModel? book;
  final String? message;

  @override
  List<Object?> get props => [status, books, book];

  BookState copyWith({
    BookStatus? status,
    List<BookModel>? books,
    BookModel? book,
    String? message
  }) {
    return BookState(
      status: status ?? this.status,
      books: books ?? this.books,
      book: book ?? this.book,
      message: message ?? this.message,
    );
  }
}