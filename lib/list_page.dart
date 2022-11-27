import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:ediya/config.dart';
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
            subtitle: Text("${person.barcode}-${person.imagePath}-${person.birth}-${person.gender}"),
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
      tiles.add(const Text("등록된 환자가 없습니다.", textAlign: TextAlign.center, style: TEXT_STYLE,));
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("환자 목록", style: TEXT_STYLE_FOR_TITLE),
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
        middle: Text("환자 정보", style: TEXT_STYLE_FOR_TITLE),
      ),
      child: ListView(
        children: [
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
                  Text(widget.person.name, style: TEXT_STYLE),
                  const Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Text(widget.person.toString(), style: TEXT_STYLE,)
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
                        title: const Text("삭제하시겠습니까?", style: TEXT_STYLE_FOR_ALERT_DIALOG),
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
                              );
                            },
                            child: const Text("예"),
                          )
                        ],
                      );
                    }
                  );
                },
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
                child: const Text("환자 삭제", style: TEXT_STYLE),
              ),
            ),
          )
        ],
      ),
    );
  }
}
