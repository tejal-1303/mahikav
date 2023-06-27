import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mahikav/components/custom_icon_icons.dart';
import 'package:mahikav/constants.dart';

import '../../send_message_blob.dart';
import '../message_form.dart';

class GroupChat extends StatefulWidget {
  const GroupChat(
      {Key? key, required this.chats, required this.user, required this.group})
      : super(key: key);
  final QuerySnapshot chats;
  final DocumentSnapshot group;
  final DocumentSnapshot user;

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('General'),
        actions: [
          IconButton(
            icon: const Icon(
              CustomIcon.search,
              size: 32,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              CustomIcon.settings,
              size: 32,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: widget.group.reference
              .collection('messages')
              .orderBy('timeSent', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.docs;
              List<Widget> list = [];
              if (data.isNotEmpty) {
                final today = DateTime.now().day;
                int day = data[0]['timeSent'].toDate().day;
                int prevDay = day;
                for (int i = 0; i < data.length; i++) {
                  prevDay = data[i]['timeSent'].toDate().day;
                  print("$day + $prevDay");
                  if ((i > 0 && day > prevDay)) {
                    String text = (day == today)
                        ? 'Today'
                        : (day == today - 1)
                            ? 'Yesterday'
                            : DateFormat.yMEd()
                                .format(data[i]['timeSent'].toDate());
                    list.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Material(
                          shape: StadiumBorder(),
                          color: kColorLight,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  list.add(
                    StreamBuilder<DocumentSnapshot>(
                      stream: data[i]['sentBy'].snapshots(),
                      builder: (context, person) {
                        if (person.hasData) {
                          bool isCur =
                              data[i]['sentBy'].id == auth.currentUser!.uid;

                          return SendMessageBlob(
                            size: size,
                            message: data[i]['message'],
                            time: data[i]['timeSent'].toDate(),
                            isFirst: (i < data.length - 1 &&
                                (data[i + 1]['sentBy'].id !=
                                    data[i]['sentBy'].id || data[i]['timeSent']
                                    .toDate()
                                    .day > data[i + 1]['timeSent']
                                    .toDate()
                                    .day)) ||
                                i == data.length - 1,
                            isLast: (i > 0 &&
                                (data[i]['sentBy'].id !=
                                    data[i - 1]['sentBy'].id ||
                                    data[i - 1]['timeSent']
                                        .toDate()
                                        .day > data[i]['timeSent']
                                        .toDate()
                                        .day)) ||
                                i == 0,
                            isRecieved: !isCur,
                            name: isCur ? 'You' : person.data?['name'],
                          );
                        }
                        return Container();
                      }
                    ),
                  );
                  day = prevDay;
                }
                String text = (day == today)
                    ? 'Today'
                    : (day == today - 1)
                        ? 'Yesterday'
                        : DateFormat.yMd()
                            .format(data[data.length - 1]['timeSent'].toDate());
                list.add(
                  Material(
                    shape: StadiumBorder(),
                    color: kColorLight,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }
              return SizedBox(
                height: size.height,
                child: Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        itemCount: list.length,
                        reverse: true,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (BuildContext context, int index) {
                          return list[index];
                        },
                      ),
                    ),
                    MessageForm(
                      group: widget.group.reference,
                      sender: widget.user.reference,
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: kColorDark,
              ),
            );
          }),
    );
  }
}
