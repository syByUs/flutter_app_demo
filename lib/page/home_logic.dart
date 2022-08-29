import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app_demo/models/application_model.dart';
import 'package:flutter_app_demo/common/db_controller.dart';
import 'package:flutter_app_demo/models/lookup_model.dart';
import 'package:flutter_app_demo/models/sqlite/app_store_sql_model.dart';
import 'package:flutter_app_demo/models/sqlite/lookup_sql_model.dart';
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
  Map<String, LookupModel> lookupListMap = HashMap();

  static const int PAGESIZE = 100; //需求更改，一次性请求100条
  String topfreeapplicationsURL = "https://itunes.apple.com/hk/rss/topfreeapplications/limit=10/json";
  String topgrossingapplicationsURL = "https://itunes.apple.com/hk/rss/topgrossingapplications/limit=${PAGESIZE}/json";

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFNode = FocusNode();

  bool get showCancel => searchFNode.hasFocus;

  bool showSearchPage = false;

  void onTapCancel() {
    searchFNode.unfocus();
  }

  double? averageUserRatingForCurrentVersion(ApplicationModel model) {
    var p = lookupListMap[model.realId!];
    return p?.averageUserRatingForCurrentVersion;
  }

  int? userRatingCountForCurrentVersion(ApplicationModel model) {
    var p = lookupListMap[model.realId!];
    return p?.userRatingCountForCurrentVersion;
  }

  @override
  void onInit() {
    print("$runtimeType onInit");
    searchController.addListener(() {
      String content = searchController.text.trim();
      if (content.length > 0) {
        sqlFuzzyQuery(content);
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
      try {
        await requestData();
        insertToDB();
      } catch (e) {
        print("err: $e");
        await queryTopFree();
        await queryTopRatingAndCount(topgrossingDataSource);
        Toast.showToast("网络请求错误，从数据库加载");
      } finally {
        print("topGrossing len: ${topgrossingDataSource.length}");
        update(['gross', 'top']);
      }
    });
    super.onReady();
  }

  @override
  void onRefresh() async {
    topFreeDataSource.clear();
    topgrossingDataSource.clear();
    try {
      await requestData();
      insertToDB();
    } catch (e) {
      await queryTopFree();
      await queryTopRatingAndCount(topgrossingDataSource);
      Toast.showToast("网络请求错误，从数据库加载");
    } finally {
      update(['gross', 'top']);
      refreshController.refreshCompleted();
    }
  }

  @override
  void onLoadMore() async {
    var list = await dbLogic.query(tableName: DBConroller.appStoreTableName, offset: topFreeDataSource.length);
    for (var p in list) {
      var content = p['content'];
      if (content is String) {
        Map<String, dynamic> map = json.decode(content);
        topFreeDataSource.add(ApplicationModel.fromJson(map));
      }
    }
    //获取lookup， 网络请求||sql查询
    await requestLookups();
    update(['top']);
    refreshController.loadComplete();
  }

  @override
  bool enableLoadMore() {
    return true;
  }

  Future requestData() async {
    print("requestData");
    await requestTopGrossingData();
    await requestTopFreeData();
    await requestLookups(); //请求详情的数据
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

  Future requestLookups() async {
    var ids = <String>[];
    await queryTopRatingAndCount(topFreeDataSource);
    for (var p in topFreeDataSource) {
      if (p.realId == null) continue;
      //如果数据库存在该lookup，则不请求
      if (lookupListMap.containsKey(p.realId!)) {
        continue;
      }
      ids.add(p.realId!);
    }
    print("ids.length: ${ids.length}, ${ids.join(",")}");
    if (ids.length == 0) {
      return;
    }
    var list = await getLookupList(ids);
    for (var p in list) {
      lookupListMap[p.trackId.toString()] = p;
    }
    dbLogic.batchInsert(tableName: DBConroller.lookupTableName, list: list.map((e) => e.sqlModel).toList());
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

  Future<List<LookupModel>> getLookupList(List<String> ids) async {
    var ret = await HttpUtil.get(
      'https://itunes.apple.com/hk/lookup',
      queryParameters: {
        'id': ids.join(','),
      },
    );
    List list = ret['results'];
    return list.map((e) => LookupModel.fromJson(e)).toList();
  }

  /// sql

  insertToDB() async {
    print("insertToDB");
    try {
      await insertGrossingToDB();
      await insertFreeToDB();
      await insertRatingAndCountDataToDB();
    } catch (e) {
      Toast.showToast("$e");
    }
  }

  Future insertGrossingToDB() async {
    insertDataToDB(tableName: DBConroller.appStoreTableName, list: topgrossingDataSource.map((e) => e.sqlModel).toList());
  }

  Future insertFreeToDB() async {
    insertDataToDB(tableName: DBConroller.appStoreTableName, list: topFreeDataSource.map((e) => e.sqlModel).toList());
  }

  Future insertRatingAndCountDataToDB() async {
    insertDataToDB(tableName: DBConroller.lookupTableName, list: lookupListMap.values.map((e) => e.sqlModel).toList());
  }

  Future insertDataToDB({required tableName, required List<JsonProtocol> list}) async {
    await dbLogic.batchInsert<JsonProtocol>(
      tableName: tableName,
      list: list,
    );
  }

  Future sqlFuzzyQuery(String content) async {
    var list = await dbLogic.fuzzyQuery(tableName: DBConroller.appStoreTableName, q: content);
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

  Future queryTopRatingAndCount(List<ApplicationModel> list) async {
    var ids = list.where((element) => element.realId != null).map((e) => e.realId!).toList();
    var queryList = await dbLogic.queryRatingAndCount(ids);
    print(queryList);
    List<LookupModel> lookup = queryList.map((e) => LookupSqlModel.fromJson(e).model).toList();
    for (var p in lookup) {
      lookupListMap[p.trackId.toString()] = p;
    }
  }

  queryTopFree() async {
    var list = await dbLogic.query(tableName: DBConroller.appStoreTableName, offset: 0);
    for (var p in list) {
      var content = p['content'];
      if (content is String) {
        Map<String, dynamic> map = json.decode(content);
        topFreeDataSource.add(ApplicationModel.fromJson(map));
      }
    }
  }
}

extension Helper on ApplicationModel {
  AppStoreSqlModel get sqlModel => AppStoreSqlModel.fromApplicationModel(this);
}
