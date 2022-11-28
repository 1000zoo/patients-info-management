import 'dart:convert';
import 'dart:io';
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
  final picker = ImagePicker();
  // Person? person;

  @override
  void initState() {
    // person = widget.helper.getPersonInfo(widget.barcode);
    super.initState();
  }

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);
    String dir = (await getApplicationDocumentsDirectory()).path;
    String newPath = join(dir, imagePath());
    _image = await File(image!.path).copy(newPath); // 가져온 이미지를 _image 에 저장

    setState(() {

    });
  }

  String imagePath() {
    var newFileName = "${widget.barcode}-${nowString()}.png";
    return newFileName;
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
        color: const Color(0xffd0cece),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Center(
            child: _image == null
                ? const Text('No image selected.', style: TEXT_STYLE)
                : Image.file(File(_image!.path))));
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("사진", style: TEXT_STYLE_FOR_TITLE),
        ),
        child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showImage(),
              SizedBox(height: MediaQuery.of(context).size.height / 5),
              if (_image == null) Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 1.2),
                        CupertinoButton(
                          padding: BUTTON_PADDING,
                          color: const Color(0x9D283FE5),
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          child:
                              const Icon(Icons.camera_alt_outlined, size: 50),
                        )
                      ],
                    ) else Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width / 1.2),
                        CupertinoButton(
                          padding: BUTTON_PADDING,
                          color: const Color(0x9D283FE5),
                          onPressed: () {
                            GallerySaver.saveImage(_image!.path).then((value) {
                              if (value.toString() == 'true') {
                                  getAlertDialog(context, "저장되었습니다.").then(
                                  Navigator.of(context).pop
                                );
                              } else {
                                  getAlertDialog(context, "알 수 없는 오류").then(
                                  Navigator.of(context).pop
                                );
                              }
                            });
                          },
                          child: const Text("저장", style: TEXT_STYLE,),
                        )
                      ],
                    )
            ]));
  }
}