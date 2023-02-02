import 'package:flutter/material.dart';
import 'package:nusantara/models/book_model.dart';
import 'package:nusantara/screens/dashboard/add_book_screen.dart';
import 'package:nusantara/screens/dashboard/dashboard_screen.dart';
import 'package:nusantara/screens/dashboard/detail_book_screen.dart';
import 'package:nusantara/screens/dashboard/edit_book_screen.dart';
import 'package:nusantara/screens/login_screen.dart';
import 'package:nusantara/screens/register_screen.dart';
import 'package:nusantara/screens/splash_screen.dart';
import 'package:nusantara/utils/screen_argument.dart';

class Routes{
  static const splashScreen = '/splash';
  static const loginScreen = '/login';
  static const registerScreen = '/register';
  static const dashboardScreen = '/dashboard';
  static const addBookScreen = '/add-book';
  static const editBookScreen = '/edit-book';
  static const detailBookScreen = '/detail-book';

  static Route<dynamic>? onGenerateRoutes(RouteSettings settings){
    switch(settings.name){
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case dashboardScreen:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case addBookScreen:
        return MaterialPageRoute(builder: (_) => const AddBookScreen());
      case editBookScreen:
        final args = settings.arguments as ScreenArgument<BookModel>;
        return MaterialPageRoute(builder: (_) => EditBookScreen(book: args.data));
      case detailBookScreen:
        final args = settings.arguments as ScreenArgument<int>;
        return MaterialPageRoute(builder: (_) => DetailBookScreen(id: args.data));
      default:
        return MaterialPageRoute(builder: (_){
          return Scaffold(
            body: Center(
              child: Text("No route defined for ${settings.name}"),
            ),
          );
        });
    }
  }
}