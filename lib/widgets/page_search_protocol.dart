
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_demo/res/styles.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class ApiListModel<T> {

  int count;
  int pageIndex;
  int pageSize;
  List<T> list;

  ApiListModel(this.count, this.pageIndex, this.pageSize, this.list);

  factory ApiListModel.fromJson(Map<String, dynamic> json) => ApiListModel(
    json['count'] ?? 0,
    json['pageIndex'] ?? 0,
    json['pageSize'] ?? 0,
    json['list'] ?? [],
  );

  Map<String, dynamic> toJson() => {
    'count': count,
    'pageIndex': pageIndex,
    'pageSize': pageSize,
    'list': list,
  };

}

const int PAGE_SIZE = 10;

mixin PageSearchProtocol on GetxController {
  Map<String, int> _pageIndex = Map();

  int _pageSize = PAGE_SIZE;

  Map<String, int> _countMap = Map();

  Map<String, int> _lengthMap = Map();

  int get pageSize => _pageSize;

  int get pageIndex => _pageIndex[_currentTag] ?? 1;

  bool get pullUpEnable => _lengthMap[_currentTag] == _pageSize;

  RefreshController refreshController = RefreshController(initialRefresh: false);

  String _currentTag = 't';

  setCurrentTag(String tag) => _currentTag = tag;

  Widget refresher({required Widget child}) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: enableLoadMore(),
      header: WaterDropHeader(),
      footer: CustomFooter(
        loadStyle: LoadStyle.ShowAlways,
        builder: (BuildContext context, LoadStatus? mode) {
          if (mode == LoadStatus.loading) {
            return Container(
              height: 55.0,
              child: Center(child: CupertinoActivityIndicator()),
            );
          } else if (mode == LoadStatus.noMore) {
            return Container(
              height: 55.0,
              child: Center(
                child: Text(
                  '到底了',
                  style: PageStyle.ts_333333_14sp,
                ),
              ),
            );
          }
          return Container();
        },
      ),
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoadMore,
      child: child,
    );
  }

  void onRefresh() async {
    pageReset();
    var data = await request();
    pageLoad(data);
    pullDownData(data);
    refreshController.refreshCompleted();
    dataUpdate();
  }

  void onLoadMore() async {
    print("onLoadMore");
    pageIndexIncrement();
    var data = await request();
    pageLoad(data);
    pullUpData(data);
    refreshController.loadComplete();
    dataUpdate();
    if (!enableLoadMore()) {
      refreshController.loadNoData();
    }
  }

  bool enableLoadMore() {
    var count = _countMap[_currentTag];
    if (count == null) {
      return false;
    }
    return count > _lengthMap[_currentTag]! && count > _pageSize;
  }

  void pullDownData(ApiListModel data) {}

  void pullUpData(ApiListModel data) {}

  void dataUpdate() {
    update();
  }

  Future<ApiListModel> request() async {
    return ApiListModel(0, pageIndex, pageSize, []);
  }

  void pageReset() {
    _pageIndex[_currentTag] = 1;
    _pageSize = PAGE_SIZE;
    _lengthMap[_currentTag] = 0;
    _countMap[_currentTag] = 0;
    refreshController.resetNoData();
    print("pageReset: $_currentTag");
  }

  void pageIndexIncrement() {
    int index = _pageIndex[_currentTag]!;
    index++;
    _pageIndex[_currentTag] = index;
  }

  void pageLoad(ApiListModel api) {
    int len = _lengthMap[_currentTag]!;
    len = api.list.length + len;
    _lengthMap[_currentTag] = len;
    _countMap[_currentTag] = api.count;
  }

  Map<String, dynamic> get pageMap {
    return {
      'pageSize': _pageSize,
      'pageIndex': _pageIndex[_currentTag],
    };
  }
}