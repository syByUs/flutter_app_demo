import 'package:flutter_app_demo/util/http_util.dart';
import 'package:flutter_test/flutter_test.dart';

//单元测试
void main() {
  test("http test", () async {
    // 假如这个请求需要一个 token
    final url = "https://itunes.apple.com/hk/rss/topfreeapplications/limit=10/json";
    var ret = await HttpUtil.get(url);
    Map<String, dynamic> feed = ret['feed'];
    var entry = feed['entry'];
    expect(entry.runtimeType, List);
  });

}
