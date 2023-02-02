import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nusantara/bloc/user/user_bloc.dart';
import 'package:nusantara/components/app_button.dart';
import 'package:nusantara/components/app_form.dart';
import 'package:nusantara/components/custom_app_bar.dart';
import 'package:nusantara/utils/app_theme.dart';
import 'package:nusantara/utils/routes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _email;
  late TextEditingController _password;
  late TextEditingController _confPassword;
  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confPassword = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar.customAppBarWithoutBackButton(title: "Register"),
      body: _registerBody(context),
    );
  }

  Widget _registerBody(BuildContext context){
    return BlocListener<UserBloc, UserState>(
      listener: (context, state){
        if(state.status == UserStatus.loading){
          EasyLoading.show(status: "Loading...");
        }
        if(state.status == UserStatus.error){
          EasyLoading.showError(state.message ?? "Error");
        }
        if(state.status == UserStatus.created){
          EasyLoading.dismiss();
          BlocProvider.of<UserBloc>(context).add(UserLogin(_email.text, _password.text));
        }
        if(state.status == UserStatus.authenticated){
          EasyLoading.dismiss();
          Navigator.pushNamedAndRemoveUntil(context, Routes.dashboardScreen, (route) => false);
        }
      },
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(1.5.h),
          child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _registerNameForm(),
                    SizedBox(height: 1.h,),
                    _registerEmailForm(),
                    SizedBox(height: 1.h,),
                    _registerPasswordForm(),
                    SizedBox(height: 1.h,),
                    _registerConfirmationPasswordForm(),
                    SizedBox(height: 3.h,),
                    _registerButton(context),
                    SizedBox(height: 1.5.h,),
                    _goToLoginScreen(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerNameForm(){
    return AppForm(
      controller: _name,
      keyboardType: TextInputType.name,
      decoration: AppTheme.inputPrefixDecoration(LineIcons.user, "Name"),
      validator: ValidationBuilder().build(),
    );
  }

  Widget _registerEmailForm(){
    return AppForm(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      decoration: AppTheme.inputEmailDecoration(),
      validator: ValidationBuilder().email('Not Valid Email').build(),
    );
  }

  Widget _registerPasswordForm(){
    return AppForm(
      controller: _password,
      keyboardType: TextInputType.text,
      isPassword: true,
      obscure: _obscure,
      decoration: AppTheme.inputPasswordDecoration(
          state: _obscure,
          onTap: (){
            setState(() {
              _obscure = !_obscure;
            });
          },
          hint: "Password"
      ),
      validator: ValidationBuilder().build(),
    );
  }

  Widget _registerConfirmationPasswordForm(){
    return AppForm(
      controller: _confPassword,
      keyboardType: TextInputType.text,
      isPassword: true,
      obscure: _obscureConfirm,
      decoration: AppTheme.inputPasswordDecoration(
          state: _obscureConfirm,
          onTap: (){
            setState(() {
              _obscureConfirm = !_obscureConfirm;
            });
          },
          hint: "Confirmation Password"
      ),
      validator: (val){
        if (val == ''){
          return "The field is required";
        }else if(val != _password.text){
          return "The password confirmation does not match";
        }else{
          return null;
        }
      },
    );
  }

  Widget _registerButton(BuildContext context){
    return AppButton(
      onPressed: (){
        if(_formKey.currentState!.validate()){
          BlocProvider.of<UserBloc>(context).add(UserRegister(_name.text, _email.text, _password.text, _confPassword.text));
        }
      },
      text: "Register",
    );
  }

  Widget _goToLoginScreen(BuildContext context){
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: "Already have an account ?",
          style: GoogleFonts.inter(color: Colors.black, fontSize: 16.sp),
          children: <TextSpan>[
            TextSpan(
                text: ' Login',
                style: GoogleFonts.inter(color: AppTheme.primaryColor, fontSize: 16.sp),
                recognizer: TapGestureRecognizer()..onTap = (){
                  Navigator.pop(context);
                })
          ]),
    );
  }
}