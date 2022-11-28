import 'package:camera/camera.dart';
import 'package:ediya/camera_page.dart';
import 'package:ediya/set_data.dart';
import 'package:ediya/sp_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ediya/list_page.dart';
import 'package:flutter/cupertino.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras[1]));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  const MyApp(this.camera, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('ko', ''),
        Locale('en', ''),
      ],
      home: MainPage(camera),
    );
  }
}


class MainPage extends StatefulWidget {
  final CameraDescription camera;
  const MainPage(this.camera, {super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final SPHelper helper = SPHelper();

  final List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: "find"),
    const BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_add_solid), label: "추가"),
    const BottomNavigationBarItem(icon: Icon(CupertinoIcons.list_bullet), label: "환자 목록"),
  ];

  @override
  void initState() {
    helper.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: items,),
      tabBuilder: (context, index) {
        switch(index) {
          // case 0:
          //   return CupertinoTabView(
          //     builder: (context) {
          //       ///TODO 1. 바코드 인식 후 사진 촬영하러 ㄱㄱ
          //       /// 1) 바코드 인식 -> 있다 -> 카메라 촬영 -> 기분 어떰? -> 저장
          //       /// 2)          -> 없다 -> 없다는 alertAlarm popup (환자를 추가하세요)
          //       return Test1();
          //     },
          //   );
          case 1:
            return SetData(helper);
          case 2:
            return ListPage(helper);
          default:
            // initState();
            return CameraPage(helper, widget.camera);
        }
      },
    );
  }
}

///TODO 해결 미뤄도 되지만 필수. 환자 삭제하기
/// TODO FINAL STEP => 참고자료 찾기 (license 걸려있으면,, 혹시,,)