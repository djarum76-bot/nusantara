import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusantara/utils/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppButton extends StatelessWidget{
  const AppButton({super.key, this.radius, this.backgroundColor, this.textColor, required this.onPressed, required this.text, this.height, this.fontSize});

  final double? radius;
  final Color? backgroundColor;
  final Color? textColor;
  final String? text;
  final double? height;
  final double? fontSize;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: height ?? 5.5.h,
      child: ElevatedButton(
        style: AppTheme.elevatedButton(radius ?? 20, backgroundColor ?? AppTheme.primaryColor),
        onPressed: onPressed,
        child: Text(
          text!,
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: fontSize ?? 16.sp),
        ),
      ),
    );
  }
}