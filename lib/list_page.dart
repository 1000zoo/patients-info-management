import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:ediya/constant.dart';
import 'package:ediya/util.dart';
import 'package:flutter/material.dart';
import 'person.dart';
import 'package:flutter/cupertino.dart';
import 'sp_helper.dart';

class ListPage extends StatefulWidget {
  final SPHelper helper;

  const ListPage(this.helper, {super.key});
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  List<Widget> getContent() {
    List<Widget> tiles = [];
    for (var person in widget.helper.getPeopleList()) {
      tiles.add(
          CupertinoListTile(
            title: Text(person.name),
            subtitle: Text("바코드:${person.barcode}/생년월일:${person.birth}/성별:${person.gender}"),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ListPageInfo(widget.helper, person)
                )
              ).then((value) {
                setState(() {

                });
              });
            },
          )
      );
    }
    if (tiles.isEmpty) {
      tiles.add(SizedBox(height: MediaQuery.of(context).size.height/30,));
      tiles.add(const Text("등록된 환자가 없습니다.", textAlign: TextAlign.center, style: DEFAULT_TEXTSTYLE,));
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("환자 목록", style: TITLE_TEXTSTYLE),
      ),
      child: ListView(
        children: getContent()
      )
    );
  }
}

///개개인의 환자 정보
///여기서 삭제 가능
///TODO 환자 이름 및 정보 깔끔하게 출력
class ListPageInfo extends StatefulWidget {
  final SPHelper helper;
  final Person person;
  const ListPageInfo(this.helper, this.person, {super.key});

  @override
  State<ListPageInfo> createState() => _ListPageInfoState();
}

class _ListPageInfoState extends State<ListPageInfo> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("환자 정보", style: TITLE_TEXTSTYLE),
      ),
      child: ListView(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: TEXTFIELD_COLOR,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.person.name, style: DEFAULT_TEXTSTYLE),
                  const Divider(
                    thickness: 1,
                    color: DIVIDER_COLOR,
                  ),
                  Text("바코드: ${widget.person.barcode}", style: DEFAULT_TEXTSTYLE),
                  Text("생년월일: ${widget.person.birth}", style: DEFAULT_TEXTSTYLE),
                  Text("성별: ${widget.person.gender}", style: DEFAULT_TEXTSTYLE),
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 2),
          Center(
            child: Center(
              child: CupertinoButton(
                padding: BUTTON_PADDING,
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text("삭제하시겠습니까?", style: ALERT_DIALOG_TEXTSTYLE),
                        actions: [
                          CupertinoButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("아니요"),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              widget.helper.removePerson(widget.person.barcode);
                              getAlertDialog(context, "삭제되었습니다.").then(
                                Navigator.of(context).pop
                              ).then(Navigator.of(context).pop);
                            },
                            child: const Text("예"),
                          )
                        ],
                      );
                    }
                  );
                },
                color: BUTTON_COLOR,
                borderRadius: BorderRadius.circular(10),
                child: const Text("환자 삭제", style: BUTTON_TEXTSTYLE),
              ),
            ),
          )
        ],
      ),
    );
  }
}
