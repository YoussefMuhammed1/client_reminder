import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test/Chats/Chat_message.dart';
import 'package:test/helper/apis.dart';
import 'package:test/helper/mydateFormat.dart';
import 'package:test/models/chatUser.dart';
import 'package:test/models/message.dart';

class chatCard extends StatefulWidget {
  final chatUser user;
  const chatCard({super.key, required this.user});

  @override
  State<chatCard> createState() => _chatCardState();
}

class _chatCardState extends State<chatCard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => Chat_message(user: widget.user)));
        },
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;

            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

            if (list.isNotEmpty) _message = list[0];
            return _message == null
                ? Container()
                : Container(
                    margin: EdgeInsets.only(top: 10, bottom: 0, right: 15),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(119, 127, 164, 209),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: (widget.user.image == null)
                                  ? NetworkImage(
                                      "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg")
                                  : NetworkImage(widget.user.image),
                              backgroundColor:
                                  Color.fromARGB(255, 100, 148, 183),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.user.name,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 37, 37, 37),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Text(
                                    _message != null
                                        ? _message!.type == Type.image
                                            ? 'Photo'
                                            : _message!.msg
                                        : widget.user.about,
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              MyDateUtil.getFormattedTime(
                                  context: context, time: _message!.sent),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 79, 79, 79),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  );
          },
        ));
  }
}
