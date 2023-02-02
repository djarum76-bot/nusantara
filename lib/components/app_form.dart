import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppForm extends StatelessWidget{
  const AppForm({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.name,
    this.validator,
    required this.decoration,
    this.isPassword = false,
    this.obscure = false,
    this.readOnly = false,
    this.onTap
  });
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final InputDecoration decoration;
  final bool isPassword;
  final bool obscure;
  final bool readOnly;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    if(keyboardType == TextInputType.multiline){
      return TextFormField(
        controller: controller,
        style: GoogleFonts.inter(fontWeight: FontWeight.w400),
        decoration: decoration,
        keyboardType: keyboardType,
        maxLines: 5,
        validator: validator,
        textCapitalization: TextCapitalization.sentences,
      );
    }else if(readOnly){
      return TextFormField(
        controller: controller,
        style: GoogleFonts.inter(fontWeight: FontWeight.w400),
        decoration: decoration,
        keyboardType: keyboardType,
        onTap: onTap,
        readOnly: readOnly,
        validator: validator,
        textCapitalization: TextCapitalization.sentences,
      );
    }else{
      if(isPassword){
        return TextFormField(
          controller: controller,
          style: GoogleFonts.inter(fontWeight: FontWeight.w400),
          decoration: decoration,
          obscureText: obscure,
          keyboardType: keyboardType,
          validator: validator,
          textCapitalization: TextCapitalization.sentences,
        );
      }else{
        return TextFormField(
          controller: controller,
          style: GoogleFonts.inter(fontWeight: FontWeight.w400),
          decoration: decoration,
          keyboardType: keyboardType,
          validator: validator,
          textCapitalization: TextCapitalization.sentences,
        );
      }
    }
  }
}