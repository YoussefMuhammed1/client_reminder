import 'package:flutter/material.dart';

import '../helper/apis.dart';
import '../models/chatUser.dart';
import '../models/message.dart';
import 'Chat_message.dart';

class AllDoctors extends StatefulWidget {
  final chatUser user;
  const AllDoctors({super.key, required this.user});

  @override
  State<AllDoctors> createState() => _AllDoctorsState();
}

class _AllDoctorsState extends State<AllDoctors> {
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
          stream: APIs.getdoctors(),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;

            // print('Data: ${jsonEncode(data![0].data())}');
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) _message = list[0];

            return Container(
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
                        backgroundImage: (widget.user.image != null)
                            ? NetworkImage(
                                "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg")
                            : NetworkImage(widget.user.image),
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
                                color: const Color.fromARGB(255, 50, 50, 50),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              widget.user.about,
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
                ],
              ),
            );

            // : Padding(
            //     padding: const EdgeInsets.all(10.0),
            //     child: ListTile(
            //       // leading: const CircleAvatar(child: Icon(CupertinoIcons.person)),
            //       leading: ClipRRect(
            //         borderRadius: BorderRadius.circular(30),
            //         child: CachedNetworkImage(
            //           width: 45,
            //           height: 45,
            //           imageUrl: widget.user.image,
            //           // placeholder: (context, url) => CircularProgressIndicator(),
            //           errorWidget: (context, url, error) => CircleAvatar(
            //               child: Icon(CupertinoIcons.person)),
            //         ),
            //       ),
            //       title: Text(widget.user.name),
            //       subtitle: Text(
            //         _message != null
            //             ? _message!.type == Type.image
            //                 ? 'Photo'
            //                 : _message!.msg
            //             : widget.user.about,
            //         maxLines: 1,
            //       ),
            //     ),
            //   );
          },
        ));
  }
}
