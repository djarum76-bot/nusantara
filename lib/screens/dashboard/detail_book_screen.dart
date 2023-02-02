import 'dart:math';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nusantara/bloc/book/book_bloc.dart';
import 'package:nusantara/components/app_dialog.dart';
import 'package:nusantara/components/custom_app_bar.dart';
import 'package:nusantara/models/book_model.dart';
import 'package:nusantara/utils/app_theme.dart';
import 'package:nusantara/utils/contants.dart';
import 'package:nusantara/utils/routes.dart';
import 'package:nusantara/utils/screen_argument.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DetailBookScreen extends StatelessWidget{
  const DetailBookScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<BookBloc>(context)..add(BookFetched(id)),
      child: Scaffold(
        appBar: CustomAppBar.customAppBarWithBackButton(context: context, title: 'Detail'),
        body: _detailBookBody(),
        floatingActionButton: _detailBookFloatingButton(context),
      ),
    );
  }

  Widget _detailBookBody(){
    return BlocListener<BookBloc, BookState>(
      listener: (context, state){
        if(state.status == BookStatus.loading){
          EasyLoading.show(status: 'Loading...');
        }
        if(state.status == BookStatus.error){
          AppDialog.errorDialog(context);
        }
        if(state.status == BookStatus.fetched && state.book != null){
          EasyLoading.dismiss();
        }
        if(state.status == BookStatus.deleted){
          EasyLoading.dismiss();
          Navigator.pop(context);
        }
      },
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(1.5.h),
          child: _detailBookBodyList(),
        ),
      ),
    );
  }

  Widget _detailBookBodyList(){
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state){
        if(state.status == BookStatus.loading){
          return const SizedBox();
        }else{
          if(state.book == null){
            return const SizedBox();
          }else{
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailBookItem(title: 'ISBN', subtitle: state.book!.isbn!),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: _detailBookItem(title: 'Title', subtitle: state.book!.title!),
                      ),
                      Expanded(
                        child: _detailBookItem(title: 'Subtitle', subtitle: state.book!.subtitle!),
                      )
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _detailBookItem(title: 'Author', subtitle: state.book!.author!),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: _detailBookItem(title: 'Published', subtitle: state.book!.published == Constants.defaultDate ? '-' : DateFormat('d MMM yyyy').format(DateTime.parse(state.book!.published!))),
                      ),
                      Expanded(
                        child: _detailBookItem(title: 'Publisher', subtitle: state.book!.publisher!),
                      )
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: _detailBookItem(title: 'Pages', subtitle: state.book!.pages == 0 ? '-' : state.book!.pages.toString()),
                      ),
                      Expanded(
                        child: _detailBookItem(title: 'Website', subtitle: state.book!.website!),
                      )
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _detailBookItem(title: 'Description', subtitle: state.book!.description!),
                ],
              ),
            );
          }
        }
      },
    );
  }

  Widget _detailBookItem({required String title, required String subtitle}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17.sp),
        ),
        Text(
          subtitle,
          style: GoogleFonts.inter(fontWeight: FontWeight.w300, color: Colors.black, fontSize: 16.sp),
          textAlign: TextAlign.justify,
        )
      ],
    );
  }

  Widget _detailBookFloatingButton(BuildContext context){
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state){
        if(state.status == BookStatus.loading){
          return const SizedBox();
        }else{
          if(state.book == null){
            return const SizedBox();
          }else{
            return CircularMenu(
              alignment: Alignment.bottomRight,
              startingAngleInRadian: 1 * pi,
              endingAngleInRadian: 1.495 * pi,
              items: [
                CircularMenuItem(
                  icon: LineIcons.edit,
                  onTap: (){
                    Navigator.pushNamed(
                      context,
                      Routes.editBookScreen,
                      arguments: ScreenArgument<BookModel>(state.book!)
                    );
                  },
                ),
                CircularMenuItem(
                  icon: LineIcons.trash,
                  color: AppTheme.redColor,
                  onTap: () => BlocProvider.of<BookBloc>(context).add(BookDeleted(id)),
                )
              ],
            );
          }
        }
      },
    );
  }
}