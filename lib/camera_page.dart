import 'package:camera/camera.dart';
import 'package:ediya/barcode.dart';
import 'package:ediya/camera_test.dart';
import 'package:ediya/config.dart';
import 'package:ediya/sp_helper.dart';
import 'package:ediya/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'set_data.dart';
import 'camera.dart';
import 'person.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraPage extends StatefulWidget {
  final SPHelper helper;
  final CameraDescription camera;

  const CameraPage(this.helper, this.camera, {super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String barcode = "";
  bool detected = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("환자 찾기", style: TEXT_STYLE_FOR_TITLE),
      ),
      child: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 12),
          CupertinoButton(
            padding: BUTTON_PADDING,
            onPressed: () async {
              barcode = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => Barcode(widget.helper),
                  ));
              detected = barcode != "";
            },
            child: const Icon(Icons.search),
          ),
          SizedBox(height: MediaQuery.of(context).size.width / 12),
          CupertinoButton(
            padding: BUTTON_PADDING,
            onPressed: () {
              if (!detected) {
                getAlertDialog(context, "바코드를 스캔하세요!");
              } else if (!widget.helper.contains(barcode)) {
                getAlertDialog(
                    context, "등록되지 않은 환자입니다!\n등록 먼저 하시거나 바코드를 다시 스캔해주세요.");
              } else {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text(
                            "${widget.helper.getPersonName(barcode)} 님이 맞습니까?"),
                        actions: [
                          CupertinoButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("아니요"),
                          ),
                          CupertinoButton(
                              onPressed: () {
                                Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => Camera(widget.helper, barcode)))
                                    .then(Navigator.of(context).pop)
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                              child: const Text("예"))
                        ],
                      );
                    });
              }
            },
            child: const Icon(Icons.camera),
          ),
        ],
      ),
    );
  }
}
