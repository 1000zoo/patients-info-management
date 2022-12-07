// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

///TextStyle
const FONT_FAMILY = 'Pretendard';

const TextStyle DEFAULT_TEXTSTYLE = TextStyle(
  color: TEXT_COLOR,
  fontSize: 40,
  fontFamily: FONT_FAMILY,
  fontWeight: FontWeight.w400,
  decoration: TextDecoration.none,
);
const TextStyle TITLE_TEXTSTYLE = TextStyle(
    color: TEXT_COLOR,
    fontSize: 30,
    fontFamily: FONT_FAMILY,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.none
);
const TextStyle ALERT_DIALOG_TEXTSTYLE = TextStyle(
    color: TEXT_COLOR,
    fontSize: 20,
    fontFamily: FONT_FAMILY,
    decoration: TextDecoration.none
);
const TextStyle BUTTON_TEXTSTYLE = TextStyle(
    color: BUTTON_TEXT_COLOR,
    fontSize: 40,
    fontFamily: FONT_FAMILY,
    decoration: TextDecoration.none
);

///Padding
const EdgeInsetsGeometry TEXT_FIELD_PADDING = EdgeInsets.only(left:130, right: 30, top: 10, bottom: 10);
const EdgeInsetsGeometry BIRTH_FIELD_PADDING = EdgeInsets.only(left:65, right: 30, top: 10, bottom: 10);


///Button
///Padding
const EdgeInsetsGeometry BUTTON_PADDING = EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10);
const EdgeInsetsGeometry MAIN_BUTTON_PADDING = EdgeInsets.only(left: 60, right: 60, top: 100, bottom: 100);

const Color BUTTON_TEXT_COLOR = Color(0xffffffff);
const Color BUTTON_COLOR = Color(0x9D5358F3);
const Color ETC_COLOR = Color(0xffd0cece);
const Color DIVIDER_COLOR = Color(0xFF000000);
const Color TEXTFIELD_COLOR = Color(0xBCCFD5FF);
const Color BARCODE_COLOR = Color(0xD53EB8CB);
const Color TEXT_COLOR = Color(0xFF000000);