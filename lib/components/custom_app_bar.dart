import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nusantara/utils/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomAppBar{
  static AppBar customAppBarWithBackButton({required BuildContext context, required String title}){
    return AppBar(
      backgroundColor: AppTheme.scaffoldColor,
      elevation: 0,
      leading: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(1.05.h),
        child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Ionicons.arrow_back, color: Colors.black),
          ),
        ),
      ),
      titleSpacing: 0,
      title: Text(
        title,
        style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 18.5.sp, color: Colors.black),
      ),
    );
  }

  static AppBar customAppBarWithoutBackButton({required String title}){
    return AppBar(
      backgroundColor: AppTheme.scaffoldColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 2.65.w,
      title: Text(
        title,
        style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 24.sp),
      ),
    );
  }
}