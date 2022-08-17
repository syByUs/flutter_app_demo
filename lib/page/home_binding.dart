import 'package:flutter_app_demo/page/home_logic.dart';
import 'package:get/get.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    print("$runtimeType dependencies");
    Get.lazyPut(() => HomeLogic());
  }
}
