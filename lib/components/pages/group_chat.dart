import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:mahikav/components/custom_icon_icons.dart';
import 'package:mahikav/components/pages/group_settings.dart';
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
  final audioPlayer = AudioPlayer();

  @override
  void dispose() {
    audioPlayer.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('General'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.call_rounded,
              size: 32,
            ),
            onPressed: () async {
              await HapticFeedback.vibrate();
              await FlutterPhoneDirectCaller.callNumber('+911090');
            },
          ),
          if(!widget.group['isGeneral'])
          IconButton(
            icon: const Icon(
              CustomIcon.settings,
              size: 32,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GroupSettings(
                    groupRef: widget.group.reference,
                    address: widget.group['collegeName'],
                  ),
                ),
              );
            },
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
                DateTime day = data[0]['timeSent'].toDate();
                int prevDay = 0;

                for (int i = 0; i < data.length; i++) {
                  list.add(
                    StreamBuilder<DocumentSnapshot>(
                        stream: data[i]['sentBy'].snapshots(),
                        builder: (context, person) {
                          if (person.hasData) {
                            bool isCur =
                                data[i]['sentBy'].id == auth.currentUser!.uid;

                            return SendMessageBlob(
                              size: size,
                              fileMessage: data[i]['message'].isEmpty
                                  ? data[i]['fileMessage']
                                  : null,
                              message: data[i]['message'],
                              time: data[i]['timeSent'].toDate(),
                              isFirst: (i < data.length - 1 &&
                                      (data[i + 1]['sentBy'].id !=
                                              data[i]['sentBy'].id ||
                                          data[i]['timeSent'].toDate().day >
                                              data[i + 1]['timeSent']
                                                  .toDate()
                                                  .day)) ||
                                  i == data.length - 1,
                              isLast: (i > 0 &&
                                      (data[i]['sentBy'].id !=
                                              data[i - 1]['sentBy'].id ||
                                          data[i - 1]['timeSent'].toDate().day >
                                              data[i]['timeSent']
                                                  .toDate()
                                                  .day)) ||
                                  i == 0,
                              isRecieved: !isCur,
                              name: isCur ? 'You' : person.data?['name'],
                              audioPlayer: AudioPlayer(),
                            );
                          }
                          return Container();
                        }),
                  );
                  int dayByNow = prevDay = -(data[i]['timeSent'] as Timestamp)
                      .toDate()
                      .difference(DateTime.now())
                      .inDays;
                  if (i < data.length - 1) {
                    prevDay = -(data[i + 1]['timeSent'] as Timestamp)
                        .toDate()
                        .difference(day)
                        .inDays;
                    int day_ = (data[i]['timeSent'] as Timestamp)
                        .toDate()
                        .difference(
                            (data[i + 1]['timeSent'] as Timestamp).toDate())
                        .inDays;
                    if (day_ != 0) {
                      String text = (dayByNow == 0)
                          ? 'Today'
                          : (dayByNow == 1)
                              ? 'Yesterday'
                              : DateFormat("dd/MM/yyyy")
                                  .format(data[i]['timeSent'].toDate());
                      list.add(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Material(
                                shape: const StadiumBorder(),
                                color: kColorLight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5.0),
                                  child: Text(
                                    text,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    day = (data[i + 1]['timeSent'] as Timestamp).toDate();
                  }
                }
                prevDay = -day.difference(DateTime.now()).inHours;
                String text = (prevDay >= 0 && prevDay < 24)
                    ? 'Today'
                    : (prevDay >= 24 && prevDay < 48)
                        ? 'Yesterday'
                        : DateFormat("dd/MM/yyyy")
                            .format(data[data.length - 1]['timeSent'].toDate());
                list.add(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Material(
                          shape: const StadiumBorder(),
                          color: kColorLight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5.0),
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
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
