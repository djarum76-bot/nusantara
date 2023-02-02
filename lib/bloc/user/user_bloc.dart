import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusantara/models/user_model.dart';
import 'package:nusantara/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(const UserState()) {
    on<UserRegister>(
      _onUserRegister
    );
    on<UserLogin>(
        _onUserLogin
    );
    on<UserLogout>(
        _onUserLogout
    );
    on<UserFetch>(
        _onUserFetch
    );
  }

  Future<void> _onUserRegister(UserRegister event, Emitter<UserState> emit)async{
    emit(state.copyWith(status: UserStatus.loading));
    try{
      await userRepository.register(event.name, event.email, event.password, event.passwordConfirmation);
      emit(state.copyWith(status: UserStatus.created));
    }catch(e){
      emit(state.copyWith(
        status: UserStatus.error,
        message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onUserLogin(UserLogin event, Emitter<UserState> emit)async{
    emit(state.copyWith(status: UserStatus.loading));
    try{
      await userRepository.login(event.email, event.password);
      emit(state.copyWith(status: UserStatus.authenticated));
    }catch(e){
      emit(state.copyWith(
          status: UserStatus.error,
          message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onUserLogout(UserLogout event, Emitter<UserState> emit)async{
    emit(state.copyWith(status: UserStatus.loading));
    try{
      await userRepository.logout();
      emit(state.copyWith(status: UserStatus.unauthenticated));
    }catch(e){
      emit(state.copyWith(
          status: UserStatus.error,
          message: e.toString()
      ));
      throw Exception(e);
    }
  }

  Future<void> _onUserFetch(UserFetch event, Emitter<UserState> emit)async{
    emit(state.copyWith(status: UserStatus.loading));
    try{
      final user = await userRepository.getUser();
      emit(state.copyWith(
        status: UserStatus.fetched,
        user: user
      ));
    }catch(e){
      emit(state.copyWith(
          status: UserStatus.error,
          message: e.toString()
      ));
      throw Exception(e);
    }
  }
}
