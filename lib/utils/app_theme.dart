import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppTheme{
  static ThemeData theme(){
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldColor,
      primarySwatch: createMaterialColor(primaryColor),
      colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(primaryColor)
      ),
    );
  }

  static InputDecoration inputDecoration(String text){
    return InputDecoration(
        border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF000000))
        ),
        labelText: text,
        hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16.sp),
    );
  }

  static InputDecoration inputPrefixDecoration(IconData icon, String text){
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.black),
      border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000))
      ),
      hintText: text,
      hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w400),
    );
  }

  static InputDecoration inputEmailDecoration(){
    return InputDecoration(
      prefixIcon: const Icon(LineIcons.envelope, color: Colors.black),
      border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000))
      ),
      hintText: 'Email',
      hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w400),
    );
  }

  static InputDecoration inputPasswordDecoration({required bool state, required void Function()? onTap, required String hint}){
    return InputDecoration(
        prefixIcon: const Icon(LineIcons.lock, color: Colors.black),
        suffixIcon: IconButton(
          onPressed: onTap,
          icon: Icon(state ? Ionicons.eye_off_outline : Ionicons.eye_outline, color: Colors.black),
        ),
        border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF000000))
        ),
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w400)
    );
  }

  static ButtonStyle elevatedButton(double radius, Color color){
    return ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        )
    );
  }

  static Color primaryColor = const Color(0xFF216AD7);
  static Color iconColor = const Color(0xFFfefefe);
  static Color scaffoldColor = const Color(0xFFFFFFFF);
  static Color redColor = const Color(0xFFF53131);

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}