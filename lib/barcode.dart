import 'package:ediya/config.dart';
import 'package:ediya/person.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'sp_helper.dart';
import 'util.dart';

///Todo ?. barcode 인식을 전면 카메라를 default 로 할 수 있는지? (가장 마지막)

class Barcode extends StatefulWidget {
  final SPHelper helper;

  const Barcode(this.helper, {super.key});


  @override
  _BarcodeState createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {
  String? _qrInfo = '스캔하세요';
  bool _camState = false;
  bool _detected = false;
  bool _contains = false;

  String? get qrInfo => _qrInfo;

  @override
  void initState() {
    super.initState();
    _init();
  }

  /// 초기화 함수
  _init() async {
    setState(() {
      // QR 코드 스캔 관련
      _camState = true;
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// QR/Bar Code 스캔 성공시 호출
  _qrCallback(String? code) {
    setState(() {
      // 동일한걸 계속 읽을 경우 한번만 소리/진동 실행..
      if (code != _qrInfo) {
        FlutterBeep.beep(); // 비프음
      }
      _camState = false;
      _qrInfo = code;
      _detected = true;
      _contains = widget.helper.contains(code.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("바코드 인식"),
        ),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.4,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    QRBarScannerCamera(
                      // 에러 발생시..
                      onError: (context, error) => Text(
                        error.toString(),
                        style: const TextStyle(color: Color(0xD53EB8CB)),
                      ),
                      // QR 이 읽혔을 경우
                      qrCodeCallback: (code) {
                        _qrCallback(code);
                      },
                    ),
                    ///TODO 바코드 박스 UI 수정
                    ///가장 인식을 잘 하는 거리에서의 크기를 찾아 수정 (노가다)
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 3.0,
                          color: const Color(0xD53EB8CB)
                        )
                      ),
                    ),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2.0,
                              color: const Color(0xD53EB8CB)
                          )
                      ),
                    )
                  ]
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              child: _detected
                  ? Center(
                      child: CupertinoButton(
                        padding: BUTTON_PADDING,
                        color: const Color(0xaa6d93e3),
                        borderRadius: BorderRadius.circular(10),
                        onPressed: () {
                          Navigator.pop(context, _qrInfo);
                        },
                        child: _contains
                          ? Text(widget.helper.getPersonName(_qrInfo.toString()), style: TEXT_STYLE,)
                          : const Text("환자정보 없음", style: TEXT_STYLE,)
                        ,
                      ),
                    )
                  : Center(child: Text(_qrInfo.toString(), style: TEXT_STYLE,))
            )

          ],
        )
    );
  }
}