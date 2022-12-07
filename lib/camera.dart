import 'dart:convert';
import 'dart:io';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:ediya/config.dart';
import 'package:ediya/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'sp_helper.dart';

class Camera extends StatefulWidget {
  final SPHelper helper;
  final String barcode;

  const Camera(this.helper, this.barcode, {Key? key}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File? _image;
  XFile? tempImage;
  final picker = ImagePicker();
  String mood = "";
  bool moodCheck = false;

  @override
  void initState() {
    super.initState();
  }

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    tempImage = await picker.pickImage(
        source: imageSource, preferredCameraDevice: CameraDevice.front);
    setState(() {});
  }

  String imagePath() {
    var newFileName = "${widget.barcode}-$mood-${nowString()}.png";
    return newFileName;
  }

  Future<void> changeImagePath() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String newPath = join(dir, imagePath());

    File temp =
        await File(tempImage!.path).copy(newPath); // 가져온 이미지를 _image 에 저장
    setState(() {
      _image = temp;
    });
    print(_image!.path);
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
        // color: ETC_COLOR,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.2,
        child: Center(
            child: tempImage == null
                ? const Text('사진을 촬영하세요.', style: DEFAULT_TEXTSTYLE)
                : Image.file(File(tempImage!.path))));
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("사진 찍기", style: TITLE_TEXTSTYLE),
        ),
        child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showImage(),
              // SizedBox(height: MediaQuery.of(context).size.height / 5),
              if (tempImage == null)
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width / 1.2),
                    CupertinoButton(
                      padding: BUTTON_PADDING,
                      color: BUTTON_COLOR,
                      onPressed: () {
                        getImage(ImageSource.camera);
                      },
                      child: const Icon(Icons.camera_alt_outlined, size: 50),
                    )
                  ],
                )
              else
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width / 20),
                    CupertinoRadioChoice(
                      choices: const {'좋음': '좋음', '그럭저럭': '그럭저럭', '나쁨': '나쁨'},
                      onChange: (selected) {
                        setState(() {
                          mood = selected;
                          moodCheck = true;
                        });
                      },
                      initialKeyValue: '그럭저럭',
                      selectedColor: BUTTON_COLOR,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 2.1),
                    CupertinoButton(
                      padding: BUTTON_PADDING,
                      color: BUTTON_COLOR,
                      onPressed: () {
                        if (!moodCheck) {
                          getAlertDialog(context, "기분을 선택하세요!");
                        } else {
                          showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text("'$mood'을 선택하신 것이 맞습니까?"),
                                  actions: [
                                    CupertinoButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("아니요"),
                                    ),
                                    CupertinoButton(
                                        onPressed: () async {
                                          await changeImagePath(); //비동기여서 에러가 생겼었음
                                          GallerySaver.saveImage(_image!.path, albumName: widget.helper.getPersonName(widget.barcode))
                                              .then((value) {
                                            if (value.toString() == 'true') {
                                              getAlertDialog(
                                                      context, "저장되었습니다.")
                                                  .then(Navigator.of(context)
                                                      .pop).then(Navigator.of(context).pop);
                                            } else {
                                              getAlertDialog(
                                                      context, "알 수 없는 오류")
                                                  .then(Navigator.of(context)
                                                      .pop);
                                            }
                                          });
                                        },
                                        child: const Text("예"))
                                  ],
                                );
                              });
                        }
                      },
                      child: const Text(
                        "저장",
                        style: DEFAULT_TEXTSTYLE,
                      ),
                    )
                  ],
                )
            ]));
  }
}

//getMoodListTile(Mood.good),
// getMoodListTile(Mood.notBad),
// getMoodListTile(Mood.bad),
