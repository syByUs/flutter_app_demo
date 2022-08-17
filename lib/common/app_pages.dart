
import 'dart:developer';
import 'dart:ui';

import 'package:flutter_app_demo/page/home_binding.dart';
import 'package:flutter_app_demo/page/home_view.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {
  static const HOME = '/initial';
}
class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
      transition: Transition.cupertino,
      preventDuplicates: true,
    ),

  ];
}

class Logger {
  // Sample of abstract logging function
  static void print(String text, {bool isError = false}) {
    log('** $text, isError [$isError]');
  }
}

const Map<String, String> en_US = {
  'welcomeUse': 'Welcome',
};
const Map<String, String> zh_CN = {
  'welcomeUse': '欢迎使用',
};

class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  static final fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': en_US,
    'zh_CN': zh_CN,
  };
}