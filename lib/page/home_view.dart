import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app_demo/models/application_model.dart';
import 'package:flutter_app_demo/page/home_logic.dart';
import 'package:flutter_app_demo/res/styles.dart';
import 'package:flutter_app_demo/widgets/avatar_view.dart';
import 'package:flutter_app_demo/widgets/search_box.dart';
import 'package:flutter_app_demo/widgets/touch_close_keyboard.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final logic = Get.find<HomeLogic>();

  Widget get searchBar => SearchBox(
        controller: logic.searchController,
        focusNode: logic.searchFNode,
        searchIconColor: PageStyle.c_D8D8D8,
        padding: EdgeInsets.only(
          left: 5.w,
        ),
      );

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          GetBuilder(
            builder: (_) {
              if (logic.showCancel)
                return InkWell(
                  onTap: logic.onTapCancel,
                  child: Container(
                    width: 50.w,
                    height: 44.h,
                    alignment: Alignment.center,
                    child: Text(
                      '取消',
                      style: PageStyle.ts_blue_14sp,
                    ),
                  ),
                );
              return Container();
            },
            init: logic,
            id: 'appbar',
          )
        ],
        title: searchBar,
      ),
      body: TouchCloseSoftKeyboard(
        child: Stack(
          children: [
            Positioned(
              child: logic.refresher(child: buildScrollView()),
            ),
            Positioned(
              child: buildSearchPage(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSearchPage() => GetBuilder(
        builder: (_) => Visibility(
          visible: logic.showSearchPage,
          child: Container(
            color: Colors.white,
            child: ListView.separated(
              itemBuilder: (ctx, index) {
                var ele = logic.queryDataSource.elementAt(index);
                return Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: PageStyle.c_979797,
                    ),
                    title: Text(
                      ele.name.label ?? '',
                      style: PageStyle.ts_333333_16sp,
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(height: 1.0),
              itemCount: logic.queryDataSource.length,
            ),
          ),
        ),
        init: logic,
        id: 'query',
      );

  Widget buildScrollView() => CustomScrollView(
        slivers: <Widget>[
          GetBuilder(
            builder: (_) => buildRecommend(),
            init: logic,
            id: 'gross',
          ),
          GetBuilder(
            builder: (_) => buildTop(),
            init: logic,
            id: 'top',
          ),
        ],
      );

  Widget buildTop() => SliverPadding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).padding.bottom),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (content, index) {
              var ele = logic.topFreeDataSource.elementAt(index);
              return buildVerticalContent(ele, index);
            },
            childCount: logic.topFreeDataSource.length,
          ),
        ),
      );

  Widget buildRecommend() => SliverPadding(
        padding: EdgeInsets.zero,
        sliver: SliverToBoxAdapter(
          child: Container(
            height: 170.h,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (logic.topgrossingDataSource.length > 0)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Text(
                      'Recommend',
                      style: PageStyle.ts_333333_18sp,
                    ),
                  ),
                if (logic.topgrossingDataSource.length > 0)
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 5.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: BorderDirectional(
                          bottom: BorderSide(
                            width: 0.5,
                            color: PageStyle.c_999999_opacity40p,
                          ),
                        ),
                      ),
                      child: CustomScrollView(
                        scrollDirection: Axis.horizontal,
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (content, index) {
                                var ele = logic.topgrossingDataSource.elementAt(index);
                                return buildHorizonalContent(ele);
                              },
                              childCount: logic.topgrossingDataSource.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      );

  Widget buildHorizonalContent(ApplicationModel ele) => Container(
        width: 100.w,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 3.h),
              child: AvatarView(
                url: ele.images.last.label,
                size: 80.h,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                "${ele.name.label}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: PageStyle.ts_333333_16sp,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                "${ele.category.attributes?['label']} ",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: PageStyle.ts_999999_12sp,
              ),
            ),
          ],
        ),
      );

  Widget buildVerticalContent(ApplicationModel ele, int index) => Container(
        height: 80.h,
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: BorderDirectional(
            bottom: BorderSide(
              width: 0.5,
              color: PageStyle.c_999999_opacity40p,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(right: 10.w),
              child: Text(
                "${index + 1}",
                style: PageStyle.ts_999999_14sp,
              ),
            ),
            AvatarView(
              url: ele.images.last.label,
              size: 60.h,
              isCircle: index % 2 != 0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(Get.context!).size.width - 120.w,
                    child: Text(
                      "${ele.name.label}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: PageStyle.ts_333333_16sp,
                    ),
                  ),
                  Container(
                    child: Text(
                      "${ele.category.attributes?['label']}",
                      maxLines: 1,
                      style: PageStyle.ts_999999_13sp,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        RatingBarIndicator(
                          rating: 3.5,
                          itemCount: 5,
                          itemSize: 15,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 3.w),
                          child: Text(
                            '(1000)',
                            style: PageStyle.ts_999999_14sp,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
