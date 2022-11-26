import 'dart:ui';

import 'package:ediya/barcode.dart';
import 'package:ediya/config.dart';
import 'package:ediya/sp_helper.dart';
import 'package:ediya/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'person.dart';
import 'package:intl/intl.dart';

class SetData extends StatefulWidget {
  final SPHelper helper;

  const SetData(this.helper, {super.key});

  @override
  State<SetData> createState() => _SetDataState();
}

class _SetDataState extends State<SetData> {

  late TextEditingController _nameController;
  late TextEditingController _barcodeController;
  late String _birthDay;

  String barcode = " ";
  bool detected = false;
  DateTime initDate = DateFormat('yyyy-MM-dd').parse('2000-01-01');


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _barcodeController = TextEditingController();
    _birthDay = initDate.toString().split(' ')[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("환자 추가하기", style: TEXT_STYLE_FOR_TITLE,),
          // backgroundColor: Color(0xFFC2DCFA),

        ),
        child: ListView(
          children: [
            // SizedBox(height: MediaQuery.of(context).size.height / 10),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoTextField.borderless(
                      controller: _nameController,
                      padding: NAME_FIELD_PADDING,
                      prefix: const Text("이름", textAlign: TextAlign.center, style: TEXT_STYLE,),
                      placeholder: '홍길동',
                      cursorHeight: 40,
                      style: TEXT_STYLE,
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    /// TODO 해결 Birthday DatePicker 키보드 안나오게 하기
                    ///디자인을 해치지 않으면서, 키보드 안나오게 하기
                    ///(TextField 말고 다른거 찾기)
                    CupertinoTextField.borderless(
                      padding: TEXT_FIELD_PADDING,
                      prefix: getText("생년월일"),
                      placeholder: _birthDay,
                      cursorHeight: 40,
                      style: TEXT_STYLE,
                      readOnly: true,
                      onTap: () => _showDialog(
                        CupertinoDatePicker(
                          minimumYear: 1900,
                          maximumYear: DateTime.now().year,
                          initialDateTime: initDate,
                          maximumDate: DateTime.now(),
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() {
                              _birthDay = newDate.toString().split(' ')[0];
                            });
                          },
                          mode: CupertinoDatePickerMode.date,
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 10),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width / 1.28),
                Column(
                  children: [
                    CupertinoButton(
                        padding: BUTTON_PADDING,
                        onPressed: () async {
                          barcode = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (BuildContext context) => Barcode(widget.helper),
                              )
                          ) ?? " ";
                          detected = barcode != " ";
                        },
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(10),
                        child: const Text("바코드", style: TEXT_STYLE,)
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 90),
                    CupertinoButton(
                      padding: BUTTON_PADDING,
                      onPressed: () {
                        if (_nameController.text.isEmpty) {
                          getAlertDialog(context, "이름을 입력하세요!");
                        } else if (!detected) {
                          getAlertDialog(context, "바코드 스캔을 하세요!");
                        } else if (widget.helper.contains(barcode)) {
                          getAlertDialog(context, "이미 등록된 환자입니다!\n바코드를 다시 스캔해 주세요.");
                        } else {
                          saveInfo();
                        }
                      },
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                      child: const Text("등록", style: TEXT_STYLE),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future saveInfo() async {
    String imagePath = "$barcode-${_nameController.text}";
    Person person = Person(
        _nameController.text,
        barcode,
        "male", imagePath, _birthDay.toString()
    );
    // widget.preferences.setString(barcode, person.toString());
    widget.helper.writeInfo(barcode, person);

    debugPrint(person.toString());
  }
}

///TODO 해결 Shared Preference
///Shared preference ? 이거를 public 으로 하는 방향으로 ?
///따로 class 를 만드는데 그 대신에 public 으로 할 것 (helper)
///
/// 이상
///
///
/// TODO 2. 사진 저장을 어떻게 할 것인지 고민