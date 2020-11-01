# ShareDemo

# 使用fluwx实现微信分享

## Getting Started

### step1:在`pubspec.yaml`添加fluwx库
```yaml
dependencies:
  flutter:
    sdk: flutter
  # https://pub.flutter-io.cn/packages/fluwx
  # https://github.com/OpenFlutter/fluwx
  fluwx: ^2.4.0
```
### step2:申请微信分享APPID
```java
@override
  void initState() {
    super.initState();
    _initFluwx();
  }
  _initFluwx() async {
    await fluwx.registerWxApi(
        appId: "微信分享appid",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "ios要填这个https://your.univerallink.com/link/");
    var result = await fluwx.isWeChatInstalled;
    print("is installed $result");
  }
```

### step3:定义分享items,ShareOpt的参数包括标题、图片、分享类型（如好友、朋友圈等），回调方法（当点击后，可以在回调中做相应的分享）
```java
final List<ShareOpt> list = [
    ShareOpt(title:'微信', img:'images/icon_wechat.jpg',shareType:ShareType.SESSION,doAction:(shareType,shareInfo)async{
      if(shareInfo == null) return;
      /// 分享到好友
      var model = fluwx.WeChatShareWebPageModel(
        shareInfo.url,
        title: shareInfo.title,
        thumbnail: fluwx.WeChatImage.network(shareInfo.img),
        scene: fluwx.WeChatScene.SESSION,
      );
      fluwx.shareToWeChat(model);
    }),
    ...
  ];
```
关于更多分享方式可以参考：
# [https://pub.flutter-io.cn/packages/fluwx](https://pub.flutter-io.cn/packages/fluwx)
# [https://github.com/OpenFlutter/fluwx](https://github.com/OpenFlutter/fluwx)

### step4:使用showModalBottomSheet弹出分享选项
```java
IconButton(
            icon: Icon(Icons.share),
            onPressed: () {

              showModalBottomSheet(
                  /**
                 * showModalBottomSheet常用属性
                 * shape 设置形状
                 * isScrollControlled：全屏还是半屏
                 * isDismissible：外部是否可以点击，false不可以点击，true可以点击，点击后消失
                 * backgroundColor : 设置背景色
                 */
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return ShareWidget(
                      ShareInfo('Hello world','http://www.baidu.com'),
                      list: widget.list,
                    );
                  });
            },
          )
```
ShareWidget包括两个参数，第一个是shareInfo这是分享的内容，第二个是list，它是分享选项ShareOpt数组。

# reference

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
