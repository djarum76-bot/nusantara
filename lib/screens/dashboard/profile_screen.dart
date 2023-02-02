import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusantara/bloc/user/user_bloc.dart';
import 'package:nusantara/components/app_button.dart';
import 'package:nusantara/components/app_dialog.dart';
import 'package:nusantara/components/custom_app_bar.dart';
import 'package:nusantara/utils/app_theme.dart';
import 'package:nusantara/utils/contants.dart';
import 'package:nusantara/utils/routes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<UserBloc>(context)..add(UserFetch()),
      child: Scaffold(
        appBar: CustomAppBar.customAppBarWithoutBackButton(title: "Profile"),
        body: _profileBody(context),
      ),
    );
  }

  Widget _profileBody(BuildContext context){
    return BlocListener<UserBloc, UserState>(
      listener: (context, state){
        if(state.status == UserStatus.loading){
          EasyLoading.show(status: "Loading...");
        }
        if(state.status == UserStatus.error){
          AppDialog.errorDialog(context);
        }
        if(state.status == UserStatus.fetched || state.user != null){
          EasyLoading.dismiss();
        }
        if(state.status == UserStatus.unauthenticated){
          EasyLoading.dismiss();
          Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
        }
      },
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state){
              if(state.status == UserStatus.loading){
                return const SizedBox();
              }else{
                return Column(
                  children: [
                    _profileData(),
                    SizedBox(height: 1.h,),
                    _profileLogoutButton(context: context),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _profileData(){
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state){
        return SizedBox(
          width: double.infinity,
          height: 12.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: CircleAvatar(
                  radius: 7.h,
                  backgroundColor: AppTheme.scaffoldColor,
                  backgroundImage: const AssetImage(Constants.user),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.user == null ? '' : state.user!.name,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 17.sp),
                    ),
                    Text(
                      state.user == null ? '' : state.user!.email,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 16.sp),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _profileLogoutButton({required BuildContext context}){
    return AppButton(
      onPressed: () => BlocProvider.of<UserBloc>(context).add(UserLogout()),
      text: "Logout",
      backgroundColor: AppTheme.redColor,
    );
  }
}