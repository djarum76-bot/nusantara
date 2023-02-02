import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<int>{
  DashboardCubit() : super(0);

  void changePage(int value){
    emit(value);
  }
}