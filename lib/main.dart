import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nusantara/bloc/book/book_bloc.dart';
import 'package:nusantara/bloc/user/user_bloc.dart';
import 'package:nusantara/repositories/book_repository.dart';
import 'package:nusantara/repositories/user_repository.dart';
import 'package:nusantara/utils/app_theme.dart';
import 'package:nusantara/utils/list_view_behavior.dart';
import 'package:nusantara/utils/routes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main()async{
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
        )
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(
          create: (context) => BookRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserBloc(userRepository: RepositoryProvider.of<UserRepository>(context)),
          ),
          BlocProvider(
            create: (context) => BookBloc(bookRepository: RepositoryProvider.of<BookRepository>(context)),
          )
        ],
        child: ResponsiveSizer(
          builder: (context, orientation, screenType){
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.theme(),
              builder: EasyLoading.init(builder: (context, child){
                return ScrollConfiguration(
                  behavior: ListViewBehavior(),
                  child: child!,
                );
              }),
              onGenerateRoute: Routes.onGenerateRoutes,
              initialRoute: Routes.splashScreen,
            );
          },
        ),
      ),
    );
  }
}