// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_app_demo/common/app_pages.dart';
import 'package:flutter_app_demo/common/db_controller.dart';
import 'package:flutter_app_demo/widgets/avatar_view.dart';
import 'package:flutter_app_demo/widgets/search_box.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_demo/main.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

//widget 测试
void main() {

  testWidgets('avatar test', (WidgetTester tester) async {
    String url = 'https://is3-ssl.mzstatic.com/image/thumb/Purple112/v4/f8/8c/8d/f88c8d46-f5d9-2540-15d1-0cca15c60435/AppIcon-0-0-1x_U007emarketing-0-0-0-2-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.jpeg/53x53bb.png';
    await tester.pumpWidget(AvatarView(url: url, size: 100, isCircle: true,));

    expect(find.byType(ClipOval), findsNothing);

    await tester.pumpWidget(AvatarView(url: url, size: 100, isCircle: false,));
    expect(find.byType(ClipRRect), findsOneWidget);

  });

  testWidgets('search box test', (WidgetTester tester) async {
    await tester.pumpWidget(SearchBox());

    expect(find.byType(TextField), findsOneWidget);
  });

  /*
  *
  Widget wrapper = ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (ctx, child) => GetMaterialApp(
        initialRoute: AppRoutes.HOME,
        getPages: AppPages.routes,
        initialBinding: InitBinding(),
      ),
    );
    await tester.pumpWidget(wrapper);
    await tester.drag(find.byType(CustomScrollView), Offset(500.0, 0.0));
    await tester.pumpAndSettle();
  * */
}
