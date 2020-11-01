import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'w_share.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// [home]这个地方，不能直接写dialog的代码，否则你会得到 "Another exception was thrown: No MaterialLocalizations found."
      /// 也不能写showModalBottomSheet的代码，否则你会得到 Another exception was thrown: No MediaQuery widget found.
      /// 正确的做法就是把所有的内容都提取出去写。如下面这样把内容都提出来写到[HomePage]
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {


  static dynamic _getShareModel(ShareType shareType,ShareInfo shareInfo){
    var scene = fluwx.WeChatScene.SESSION;
    switch(shareType){
      case ShareType.SESSION:
        scene = fluwx.WeChatScene.SESSION;
        break;
      case ShareType.TIMELINE:
        scene = fluwx.WeChatScene.TIMELINE;
        break;
      case ShareType.COPY_LINK:

        break;
      case ShareType.DOWNLOAD:

        break;
    }

    if(shareInfo.img != null) {
      return fluwx.WeChatShareWebPageModel(
        shareInfo.url,
        title: shareInfo.title,
        thumbnail: fluwx.WeChatImage.network(shareInfo.img),
        scene: scene,
      );
    }else{
      return fluwx.WeChatShareWebPageModel(
        shareInfo.url,
        title: shareInfo.title,
        scene: scene,
      );
    }
  }

  final List<ShareOpt> list = [
    ShareOpt(title:'微信', img:'images/icon_wechat.jpg',shareType:ShareType.SESSION,doAction:(shareType,shareInfo)async{
      var model = _getShareModel(shareType, shareInfo);
      fluwx.shareToWeChat(model);
    }),
    ShareOpt(title:'朋友圈', img:'images/icon_wechat_moments.jpg',shareType:ShareType.TIMELINE,doAction: (shareType,shareInfo){
      var model = _getShareModel(shareType, shareInfo);
      fluwx.shareToWeChat(model);
    }),
    ShareOpt(title:'复制', img:'images/icon_copy.png',shareType:ShareType.COPY_LINK,doAction: (shareType,shareInfo){}),
    ShareOpt(title:'链接', img:'images/icon_copylink.png',shareType:ShareType.COPY_LINK,doAction: (shareType,shareInfo){
      if(shareType == ShareType.COPY_LINK){
        ClipboardData data = new ClipboardData(text: shareInfo.url);
        Clipboard.setData(data);
      }
    }),
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    _initFluwx();
  }
  /// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  _initFluwx() async {
    await fluwx.registerWxApi(
        appId: "wxd930ea5d5a258f4f",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://your.univerallink.com/link/");
    var result = await fluwx.isWeChatInstalled;
    print("is installed $result");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分享'),
        actions: <Widget>[
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
          ),
        ],
      ),
      body: Center(),
    );
  }
}

