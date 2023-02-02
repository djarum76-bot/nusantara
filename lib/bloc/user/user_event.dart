part of 'user_bloc.dart';

abstract class UserEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class UserRegister extends UserEvent{
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  UserRegister(this.name, this.email, this.password, this.passwordConfirmation);
}

class UserLogin extends UserEvent{
  final String email;
  final String password;

  UserLogin(this.email, this.password);
}

class UserLogout extends UserEvent{}

class UserFetch extends UserEvent{}