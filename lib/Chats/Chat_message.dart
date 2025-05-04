import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test/helper/mydateFormat.dart';
import '../helper/apis.dart';
import '../models/chatUser.dart';
import '../models/message.dart';

class Chat_message extends StatefulWidget {
  final chatUser user;

  const Chat_message({super.key, required this.user});

  @override
  State<Chat_message> createState() => _Chat_messageState();
}

class _Chat_messageState extends State<Chat_message> {
  bool _isUploading = false;
  List<Message> _list = [];
  final _textController = TextEditingController();

  _buildMessage(Message message) {
    if (message.read.isEmpty) {
      APIs.updateMessageReadStatus(message);
      print("updated--------------------------------------");
    }
    return Container(
      margin: APIs.user.uid == message.fromId
          ? EdgeInsets.only(top: 8, bottom: 8, left: 80)
          : EdgeInsets.only(top: 8, bottom: 8, right: 80),
      decoration: BoxDecoration(
          color: APIs.user.uid == message.fromId
              ? Color.fromARGB(255, 248, 249, 236)
              : Color(0xFFFFEFEE),
          borderRadius: APIs.user.uid == message.fromId
              ? BorderRadius.only(
                  topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))
              : BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MyDateUtil.getFormattedTime(context: context, time: message.sent),
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 8,
          ),
          message.type == Type.text
              ? Text(
                  message.msg,
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: message.msg,
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.image,
                      size: 70,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();

              final XFile? image = await picker.pickImage(
                  source: ImageSource.camera, imageQuality: 70);
              if (image != null) {
                setState(() => _isUploading = true);
                await APIs.sendChatImage(widget.user, File(image.path));
                setState(() => _isUploading = false);
              }
            },
            icon: Icon(Icons.camera_alt),
            iconSize: 25,
            color: Color.fromARGB(255, 100, 148, 183),
          ),
          IconButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final List<XFile> images =
                  await picker.pickMultiImage(imageQuality: 70);

              for (var i in images) {
                setState(() => _isUploading = true);
                await APIs.sendChatImage(widget.user, File(i.path));
                setState(() => _isUploading = false);
              }
            },
            icon: Icon(Icons.photo),
            iconSize: 25,
            color: Color.fromARGB(255, 100, 148, 183),
          ),
          Expanded(
              child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: _textController,
            decoration:
                InputDecoration.collapsed(hintText: 'Send a Message...'),
          )),
          IconButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text, Type.text);
                _textController.text = '';
              }
            },
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Color.fromARGB(255, 100, 148, 183),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 174, 73, 102),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 174, 73, 102),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0, right: 20),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 24,
                backgroundImage: (widget.user.image == null)
                    ? NetworkImage(
                        "https://t4.ftcdn.net/jpg/04/99/93/31/360_F_499933117_ZAUBfv3P1HEOsZDrnkbNCt4jc3AodArl.jpg")
                    : NetworkImage(widget.user.image),
              ),
            ),
            Text(
              widget.user.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: StreamBuilder(
                stream: APIs.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;

                      _list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (_list.isNotEmpty) {
                        return ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          child: ListView.builder(
                              padding: EdgeInsets.only(top: 15),
                              reverse: true,
                              itemCount: _list.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return _buildMessage(_list[index]);
                              }),
                        );
                      } else {
                        return Center(
                            child: Text(
                          "Say Hi !",
                          style: TextStyle(fontSize: 20),
                        ));
                      }
                  }
                },
              ),
            ),
          ),
          if (_isUploading)
            Container(
              color: Colors.white,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          _buildMessageComposer(),
        ],
      ),
    );
  }
}
