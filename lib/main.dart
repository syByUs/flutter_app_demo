import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_demo/common/app_pages.dart';
import 'package:flutter_app_demo/common/db_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {
  var brightness = Brightness.light;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: brightness,
    statusBarIconBrightness: brightness,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (ctx, child) {
        print("$runtimeType build...");
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          enableLog: true,
          logWriterCallback: Logger.print,
          initialRoute: AppRoutes.HOME,
          getPages: AppPages.routes,
          initialBinding: InitBinding(),
          locale: TranslationService.locale,
          fallbackLocale: TranslationService.fallbackLocale,
          translations: TranslationService(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}


class InitBinding extends Bindings {
  @override
  void dependencies() {
    print("InitBinding");
    Get.put<DBConroller>(DBConroller());
  }
}
