import 'package:flutter/material.dart';
import 'package:nusantara/services/storage_service.dart';
import 'package:nusantara/utils/contants.dart';
import 'package:nusantara/utils/routes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), (){
      if(StorageService.box.read(Constants.isAutoLogin) == null){
        Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
      }else{
        if(StorageService.box.read(Constants.isAutoLogin)){
          Navigator.pushNamedAndRemoveUntil(context, Routes.dashboardScreen, (route) => false);
        }else{
          Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _splashBody(),
    );
  }

  Widget _splashBody(){
    return SafeArea(
      child: Center(
        child: Image.asset(
          Constants.logo,
          width: 80.w,
          height: 40.h,
        ),
      ),
    );
  }
}