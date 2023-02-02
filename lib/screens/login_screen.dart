import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusantara/bloc/user/user_bloc.dart';
import 'package:nusantara/components/app_button.dart';
import 'package:nusantara/components/app_form.dart';
import 'package:nusantara/components/custom_app_bar.dart';
import 'package:nusantara/utils/app_theme.dart';
import 'package:nusantara/utils/routes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _email;
  late TextEditingController _password;
  bool _obscure = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar.customAppBarWithoutBackButton(title: "Login"),
      body: _loginBody(context),
    );
  }

  Widget _loginBody(BuildContext context){
    return BlocListener<UserBloc, UserState>(
      listener: (context, state){
        if(state.status == UserStatus.loading){
          EasyLoading.show(status: "Loading...");
        }
        if(state.status == UserStatus.error){
          EasyLoading.showError(state.message ?? "Error");
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
                    _loginEmailForm(),
                    SizedBox(height: 1.h,),
                    _loginPasswordForm(),
                    SizedBox(height: 3.h,),
                    _loginButton(context),
                    SizedBox(height: 1.5.h,),
                    _goToRegisterScreen(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginEmailForm(){
    return AppForm(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      decoration: AppTheme.inputEmailDecoration(),
      validator: ValidationBuilder().email('Not Valid Email').build(),
    );
  }

  Widget _loginPasswordForm(){
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

  Widget _loginButton(BuildContext context){
    return AppButton(
      onPressed: (){
        if(_formKey.currentState!.validate()){
          BlocProvider.of<UserBloc>(context).add(UserLogin(_email.text, _password.text));
        }
      },
      text: "Login",
    );
  }

  Widget _goToRegisterScreen(BuildContext context){
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: "Don't have an account ?",
          style: GoogleFonts.inter(color: Colors.black, fontSize: 16.sp),
          children: <TextSpan>[
            TextSpan(
                text: ' Register',
                style: GoogleFonts.inter(color: AppTheme.primaryColor, fontSize: 16.sp),
                recognizer: TapGestureRecognizer()..onTap = (){
                  Navigator.pushNamed(context, Routes.registerScreen);
                })
          ]),
    );
  }
}