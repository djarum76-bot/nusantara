part of 'book_bloc.dart';

abstract class BookEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class BookAdded extends BookEvent{
  final BookModel book;

  BookAdded(this.book);
}

class BookDeleted extends BookEvent{
  final int id;

  BookDeleted(this.id);
}

class BookEdited extends BookEvent{
  final BookModel book;

  BookEdited(this.book);
}

class BooksFetched extends BookEvent{}

class BookFetched extends BookEvent{
  final int id;

  BookFetched(this.id);
}