
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Toast {

  static void showToast(String msg) {
    if (msg.trim().isNotEmpty) EasyLoading.showToast(msg);
  }
}