import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app_demo/models/application_model.dart';
import 'package:flutter_app_demo/common/db_controller.dart';
import 'package:flutter_app_demo/models/sqlite/app_store_sql_model.dart';
import 'package:flutter_app_demo/util/http_util.dart';
import 'package:flutter_app_demo/widgets/loading_view.dart';
import 'package:flutter_app_demo/widgets/page_search_protocol.dart';
import 'package:flutter_app_demo/widgets/toast.dart';
import 'package:get/get.dart';

class HomeLogic extends GetxController with PageSearchProtocol {
  DBConroller dbLogic = Get.find<DBConroller>();

  var topFreeDataSource = <ApplicationModel>[];
  var topgrossingDataSource = <ApplicationModel>[];
  var queryDataSource = <ApplicationModel>[];

  static const int PAGESIZE = 10;
  String topfreeapplicationsURL = "https://itunes.apple.com/hk/rss/topfreeapplications/limit=${PAGESIZE}/json";
  String topgrossingapplicationsURL = "https://itunes.apple.com/hk/rss/topgrossingapplications/limit=${PAGESIZE}/json";

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFNode = FocusNode();

  bool get showCancel => searchFNode.hasFocus;

  bool showSearchPage = false;

  void onTapCancel() {
    searchFNode.unfocus();
  }

  @override
  void onInit() {
    print("$runtimeType onInit");
    searchController.addListener(() {
      String content = searchController.text.trim();
      if (content.length > 0) {
        sqlQuery(content);
      }
    });
    searchFNode.addListener(() {
      print("searchFNode ...${searchFNode.hasFocus}");
      if (searchFNode.hasFocus) {
        showSearchPage = true;
      } else {
        showSearchPage = false;
        searchController.text = '';
        queryDataSource.clear();
      }
      update(['query']);
      update(['appbar']);
    });
    super.onInit();
  }

  @override
  void onClose() {
    print("$runtimeType onClose");
    super.onClose();
  }

  @override
  void onReady() {
    print("$runtimeType onReady");
    LoadingView.singleton.wrap(asyncFunction: () async {
      await requestData();
      await insertToDB();
      update(['gross', 'top']);
    });
    super.onReady();
  }

  @override
  void onRefresh() async {
    topFreeDataSource.clear();
    topgrossingDataSource.clear();
    await requestData();
    update(['gross', 'top']);
    refreshController.refreshCompleted();
    insertToDB();
  }

  @override
  void onLoadMore() async {
    var list = await requestTopFreeData();
    update(['top']);
    refreshController.loadComplete();
    insertDataToDB(list);
  }

  @override
  bool enableLoadMore() {
    return true;
  }

  Future sqlQuery(String content) async {
    var list = await dbLogic.query(tableName: DBConroller.appStoreTableName, q: content);
    queryDataSource.clear();
    for (var p in list) {
      var content = p['content'];
      if (content is String) {
        Map<String, dynamic> map = json.decode(content);
        queryDataSource.add(ApplicationModel.fromJson(map));
      }
    }
    update(['query']);
  }

  Future<List<ApplicationModel>> requestTopGrossingData() async {
    var listgross = await getApplications(topgrossingapplicationsURL);
    topgrossingDataSource.addAll(listgross);
    return listgross;
  }

  Future<List<ApplicationModel>> requestTopFreeData() async {
    var listFree = await getApplications(topfreeapplicationsURL);
    topFreeDataSource.addAll(listFree);
    return listFree;
  }

  Future requestData() async {
    print("requestData");
    try {
      await requestTopGrossingData();
      await requestTopFreeData();
    } catch (e) {
      Toast.showToast("$e");
    }
  }

  insertToDB() async {
    print("insertToDB");
    try {
      await insertGrossingToDB();
      await insertFreeToDB();
    } catch (e) {
      Toast.showToast("$e");
    }
  }

  Future insertGrossingToDB() async {
    insertDataToDB(topgrossingDataSource);
  }

  Future insertFreeToDB() async {
    insertDataToDB(topFreeDataSource);
  }

  Future insertDataToDB(List<ApplicationModel> list) async {
    await dbLogic.batchInsert<AppStoreSqlModel>(
      tableName: DBConroller.appStoreTableName,
      list: list.map((e) => e.sqlModel).toList(),
    );
  }

  Future<List<ApplicationModel>> getApplications(String url) async {
    var ret = await HttpUtil.get(url);
    Map<String, dynamic> feed = ret['feed'];
    var entry = feed['entry'];
    var dataSource = <ApplicationModel>[];
    if (entry is Map<String, dynamic>) {
      var application = ApplicationModel.fromJson(entry);
      dataSource.add(application);
    } else if (entry is List) {
      dataSource.addAll(entry.map((e) => ApplicationModel.fromJson(e)).toList());
    }
    return dataSource;
  }
}

extension Helper on ApplicationModel {
  AppStoreSqlModel get sqlModel => AppStoreSqlModel.fromApplicationModel(this);
}
