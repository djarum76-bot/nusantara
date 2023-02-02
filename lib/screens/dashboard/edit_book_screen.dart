import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';
import 'package:nusantara/bloc/book/book_bloc.dart';
import 'package:nusantara/components/app_button.dart';
import 'package:nusantara/components/app_dialog.dart';
import 'package:nusantara/components/app_form.dart';
import 'package:nusantara/components/custom_app_bar.dart';
import 'package:nusantara/models/book_model.dart';
import 'package:nusantara/utils/app_theme.dart';
import 'package:nusantara/utils/contants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditBookScreen extends StatefulWidget{
  const EditBookScreen({super.key, required this.book});
  final BookModel book;

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _isbn;
  late TextEditingController _title;
  late TextEditingController _subtitle;
  late TextEditingController _author;
  late TextEditingController _published;
  late TextEditingController _publisher;
  late TextEditingController _pages;
  late TextEditingController _description;
  late TextEditingController _website;

  late DateTime _now;
  late String _date;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isbn = TextEditingController(text: widget.book.isbn);
    _title = TextEditingController(text: widget.book.title);
    _subtitle = TextEditingController(text: widget.book.subtitle == Constants.defaultString ? '' : widget.book.subtitle);
    _author = TextEditingController(text: widget.book.author == Constants.defaultString ? '' : widget.book.author);
    _published = TextEditingController(text: widget.book.published == Constants.defaultDate ? '' : DateFormat('d MMM yyyy').format(DateTime.parse(widget.book.published!)));
    _publisher = TextEditingController(text: widget.book.publisher == Constants.defaultString ? '' : widget.book.publisher);
    _pages = TextEditingController(text: widget.book.pages == 0 ? '' : widget.book.pages.toString());
    _description = TextEditingController(text: widget.book.description == Constants.defaultString ? '' : widget.book.description);
    _website = TextEditingController(text: widget.book.website == Constants.defaultString ? '' : widget.book.website);

    _now = widget.book.published! == Constants.defaultDate ? DateTime.now() : DateTime.parse(widget.book.published!);
    _date = widget.book.published!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _isbn.dispose();
    _title.dispose();
    _subtitle.dispose();
    _author.dispose();
    _published.dispose();
    _publisher.dispose();
    _pages.dispose();
    _description.dispose();
    _website.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar.customAppBarWithBackButton(context: context, title: 'Edit'),
      body: _editBookBody(),
    );
  }

  Widget _editBookBody(){
    return BlocListener<BookBloc, BookState>(
      listener: (context, state){
        if(state.status == BookStatus.loading){
          EasyLoading.show(status: 'Loading...');
        }
        if(state.status == BookStatus.error){
          AppDialog.errorDialog(context);
        }
        if(state.status == BookStatus.edited){
          EasyLoading.dismiss();
          Navigator.pop(context);
        }
      },
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            children: [
              _editBookForm(context),
              _editBookButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _editBookForm(BuildContext context){
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AppForm(
                controller: _isbn,
                keyboardType: TextInputType.number,
                decoration: AppTheme.inputDecoration('ISBN'),
                validator: ValidationBuilder().build(),
              ),
              SizedBox(height: 1.h,),
              AppForm(
                controller: _title,
                keyboardType: TextInputType.text,
                decoration: AppTheme.inputDecoration('Title'),
                validator: ValidationBuilder().build(),
              ),
              SizedBox(height: 1.h,),
              AppForm(
                controller: _subtitle,
                keyboardType: TextInputType.text,
                decoration: AppTheme.inputDecoration('Subtitle'),
              ),
              SizedBox(height: 1.h,),
              AppForm(
                controller: _author,
                keyboardType: TextInputType.text,
                decoration: AppTheme.inputDecoration('Author'),
              ),
              SizedBox(height: 1.h,),
              AppForm(
                controller: _published,
                keyboardType: TextInputType.text,
                decoration: AppTheme.inputDecoration('Published'),
                readOnly: true,
                onTap: ()async{
                  await _calendarDialog(context);
                },
              ),
              SizedBox(height: 1.h,),
              AppForm(
                controller: _publisher,
                keyboardType: TextInputType.text,
                decoration: AppTheme.inputDecoration('Publisher'),
              ),
              SizedBox(height: 1.h,),
              AppForm(
                controller: _pages,
                keyboardType: TextInputType.number,
                decoration: AppTheme.inputDecoration('Pages'),
                validator: (val){
                  if(val! == '0'){
                    return "Pages must be over 0";
                  }else{
                    return null;
                  }
                },
              ),
              SizedBox(height: 1.h,),
              AppForm(
                controller: _description,
                keyboardType: TextInputType.multiline,
                decoration: AppTheme.inputDecoration('Description'),
              ),
              SizedBox(height: 1.h,),
              AppForm(
                controller: _website,
                keyboardType: TextInputType.text,
                decoration: AppTheme.inputDecoration('Website'),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _calendarDialog(BuildContext context)async{
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _now,
        firstDate: DateTime(1900),
        lastDate: DateTime.now()
    );

    if(!mounted) return;
    if(picked != null){
      setState(() {
        _now = picked;
        _date = picked.toIso8601String();
      });
      _published.text = DateFormat('d MMM yyyy').format(picked);
    }
  }

  Widget _editBookButton(BuildContext context){
    return AppButton(
      onPressed: (){
        if(_formKey.currentState!.validate()){
          Map<String, dynamic> item = {
            Constants.id: widget.book.id!,
            Constants.isbn : _isbn.text,
            Constants.title : _title.text,
            Constants.subtitle : _subtitle.text == '' ? Constants.defaultString : _subtitle.text,
            Constants.author : _author.text == '' ? Constants.defaultString : _author.text,
            Constants.published : _date == Constants.defaultDate ? Constants.defaultDate : _date,
            Constants.publisher : _publisher.text == '' ? Constants.defaultString : _publisher.text,
            Constants.pages : _pages.text == '' ? 0 : int.parse(_pages.text),
            Constants.description : _description.text == '' ? Constants.defaultString : _description.text,
            Constants.website : _website.text == '' ? Constants.defaultString : _website.text,
          };

          BookModel book = BookModel.fromMap(item);
          BlocProvider.of<BookBloc>(context).add(BookEdited(book));
        }
      },
      text: 'Edit',
    );
  }
}