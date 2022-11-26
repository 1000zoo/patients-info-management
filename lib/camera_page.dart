import 'package:ediya/barcode.dart';
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

  const CameraPage(this.helper, {super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("환자 찾기", style: TEXT_STYLE_FOR_TITLE),
      ),
      child: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.width / 12),
          CupertinoButton(
            padding: BUTTON_PADDING,
            onPressed: () async {
              barcode = await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Barcode(widget.helper),
                )
              );
            },
            child: const Icon(Icons.search),
          ),
          SizedBox(height: MediaQuery.of(context).size.width / 12),
          // CupertinoButton(
          //   padding: BUTTON_PADDING,
          //   onPressed: ()  {
          //     if (barcode == 'x') {
          //       getAlertDialog(context, "등록되지 않은 환자입니다!");
          //     } else {
          //       Navigator.push(
          //         context,
          //         CupertinoPageRoute(
          //           builder: (context) => const Camera()
          //         )
          //       );
          //     }
          //   },
          //   child: const Icon(Icons.camera),
          // ),
        ],
      ),
    );
  }
}

