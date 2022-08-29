# flutter_app_demo

### 运行

**运行环境**

```
Flutter 2.10.2 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 097d3313d8 (6 months ago) • 2022-02-18 19:33:08 -0600
Engine • revision a83ed0e5e3
Tools • Dart 2.16.1 • DevTools 2.9.2
```

运行步骤：

1、Android Studio

2、选择iOS模拟器（我本地测试用的是iOS）

3、打开`pubspec.yaml`，右上角执行`pub get`；或者terminal内执行`flutter pub get`

3、Android Studio内的Terminal执行`flutter run`

### 代码结构

> main.dart
>
> lib
>
> > common 【公共】
> >
> > models 【模型】
> >
> > page 【页面】
> >
> > res 【资源】
> >
> > util 【工具】
> >
> > widgets【公共的widge】

### 采用状态管理框架

GetX

### 主页逻辑

类：

> home_bind.dart
>
> home_logic.dart
>
> home_view.dart

**home_logic**

```
home_logic充当viewModel的角色，在这里进行逻辑的处理；
比如网络数据请求到来时，通过GetX通知home_view指定的widget刷新；
```

**home_view**

```
装载具体的UI，负责页面的显示；
```

### 数据存储

Sqlite

**实现类**

> db_controller.dart

app启动时，初始化db，创建必要的db与table;



**网络请求的model 与 sql model隔离**

```
sql存储可能只是网络数据的一部分，同时，数据格式上会有不同，如果采用同一个model，如果发生需求变更的时候，会异常的难以处理；
```



### 网络请求

**http_util**简单封装了dio

### 单元测试

* unit_test `单元测试`
* widget_test ` widget测试`
* App_test.dart `集成测试`

### 未实现逻辑

1、页面加载到最底部的时候，自动加载新的一页；

```
原因：未找到接口分页的方法，所以每次分页均为同一页数据
```

2、列表页app的分数与评价数量

```
原因：接口返回内容无该数据，demo显示内容是代码内写死数据；
```



### 2.0.0 测试版本发布

**更新内容**

```
1、修复EasyLoading.init的问题
2、增加批量获取lookup数据
3、更新home_logic的部分数据获取逻辑；
```



