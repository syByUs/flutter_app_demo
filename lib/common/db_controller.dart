import 'package:flutter_app_demo/models/sqlite/app_store_sql_model.dart';
import 'package:get/get.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../widgets/toast.dart';

class DBConroller extends GetxController {
  late Future<Database> database;
  static const String dbName = 'appDemo.db';
  static const String appStoreTableName = 'appStore';

  @override
  void onInit() async {
    print("$runtimeType onInit");
    await initializationDB();
    super.onInit();
  }

  @override
  void onClose() {
    print("$runtimeType onClose");
    _closeDatabase();
    super.onClose();
  }

  initializationDB() async {
    try {
      print("openDB:...");
      String path = (await getApplicationDocumentsDirectory()).path;
      print("openDB: $path");
      database = openDatabase(
        "$path/$dbName",
        onCreate: (db, version) {
          String sql = "CREATE TABLE $appStoreTableName(id TEXT PRIMARY KEY, name TEXT, namePinyin TEXT, summary TEXT, artist TEXT, content TEXT)";
          db.execute(sql);
        },
        version: 1,
      );
    } catch (e) {
      print("$e");
      Toast.showToast("$e");
    }
  }

  Future<void> batchInsert<T extends JsonProtocol>({required String tableName, required List<T> list}) async {
    var db = await database;
    var batch = await db.batch();
    for (var p in list) {
      batch.insert(
        tableName,
        p.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<Map<String, Object?>>> fuzzyQuery({required String tableName, required String q}) async {
    String sql = '';
    if (ChineseHelper.isChinese(q)) {
      sql = "SELECT * FROM $tableName WHERE name like '%$q%' OR summary like '%$q%' OR artist like '%$q%';";
    } else {
      sql = "SELECT * FROM $tableName WHERE namePinyin like '%$q%' OR summary like '%$q%' OR artist like '%$q%';";
    }
    print("sql: $sql");
    var db = await database;
    var list = await db.rawQuery(sql);
    return list;
  }

  Future<List<Map<String, Object?>>> query({required String tableName, required int offset}) async {
    var db = await database;
    var list = await db.query(tableName, limit: 10, offset: offset);
    for (var p in list) {
      print("${p['id']}|${p['name']}");
    }
    return list;
  }

  void _closeDatabase() async {
    var db = await database;
    print(db.isOpen);
    await db.close();
    print(db.isOpen);
  }
}
