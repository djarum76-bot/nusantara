import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:nusantara/bloc/book/book_bloc.dart';
import 'package:nusantara/components/app_dialog.dart';
import 'package:nusantara/components/custom_app_bar.dart';
import 'package:nusantara/models/book_model.dart';
import 'package:nusantara/utils/contants.dart';
import 'package:nusantara/utils/routes.dart';
import 'package:nusantara/utils/screen_argument.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<BookBloc>(context)..add(BooksFetched()),
      child: Scaffold(
        appBar: CustomAppBar.customAppBarWithoutBackButton(title: 'Home'),
        body: _homeBody(context),
        floatingActionButton: _homeFloatingButton(context),
      ),
    );
  }

  Widget _homeBody(BuildContext context){
    return BlocListener<BookBloc, BookState>(
      listener: (context, state){
        if(state.status == BookStatus.loading){
          EasyLoading.show(status: 'Loading...');
        }
        if(state.status == BookStatus.error){
          AppDialog.errorDialog(context);
        }
        if(state.status == BookStatus.fetched){
          EasyLoading.dismiss();
        }
      },
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: _homeBookList(context),
        ),
      ),
    );
  }

  Widget _homeBookList(BuildContext context){
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state){
        if(state.status == BookStatus.loading){
          return const SizedBox();
        }else{
          if(state.books.isEmpty){
            return Center(
              child: Lottie.asset(Constants.noData),
            );
          }else{
            return ListView.builder(
              itemCount: state.books.length,
              itemBuilder: (context, index){
                return _homeBookItem(context, state.books[index]);
              },
            );
          }
        }
      },
    );
  }

  Widget _homeBookItem(BuildContext context, BookModel book){
    return ListTile(
      onTap: (){
        Navigator.pushNamed(
          context,
          Routes.detailBookScreen,
          arguments: ScreenArgument<int>(book.id!)
        );
      },
      title: Text(
        book.title!,
        style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17.sp),
      ),
      subtitle: Text(
        book.subtitle!,
        style: GoogleFonts.inter(fontWeight: FontWeight.w300, color: Colors.black, fontSize: 16.sp),
      ),
    );
  }

  Widget _homeFloatingButton(BuildContext context){
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, Routes.addBookScreen),
      child: const Center(
        child: Icon(LineIcons.plus),
      ),
    );
  }
}