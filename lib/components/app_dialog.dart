import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusantara/components/app_button.dart';
import 'package:nusantara/services/storage_service.dart';
import 'package:nusantara/utils/app_theme.dart';
import 'package:nusantara/utils/contants.dart';
import 'package:nusantara/utils/routes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppDialog{
  static AwesomeDialog errorDialog(BuildContext context){
    return AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        body: Padding(
          padding: EdgeInsets.all(1.5.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Error',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.redColor, fontSize: 18.sp),
              ),
              SizedBox(height: 2.h,),
              Text(
                'There seems to be something wrong with your network',
                style: GoogleFonts.inter(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h,),
              AppButton(
                onPressed: ()async{
                  StorageService.box.remove(Constants.token);
                  StorageService.box.remove(Constants.isAutoLogin);
                  StorageService.box.erase();

                  Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
                },
                text: 'Logout',
                backgroundColor: AppTheme.redColor,
              ),
              SizedBox(height: 1.h,),
            ],
          ),
        )
    )..show();
  }
}