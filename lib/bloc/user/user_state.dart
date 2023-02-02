part of 'user_bloc.dart';

enum UserStatus { initial, loading, error, authenticated, unauthenticated, created, fetched }

class UserState extends Equatable{
  const UserState({
    this.status = UserStatus.initial,
    this.user,
    this.message
  });

  final UserStatus status;
  final UserModel? user;
  final String? message;

  @override
  List<Object?> get props => [status, user];

  UserState copyWith({
    UserStatus? status,
    UserModel? user,
    String? message
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message
    );
  }
}