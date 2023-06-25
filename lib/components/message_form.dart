import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import 'custom_icon_icons.dart';

class MessageForm extends StatefulWidget {
  const MessageForm({
    super.key,
    required this.group, required this.sender,
  });
  final DocumentReference sender;
  final DocumentReference group;

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  String? message;
  final ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide()),
      ),
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              controller: ctrl,
              onChanged: (val) {
                message = val;
                setState(() {});
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Send message',
                hintStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Color(0xffD8DADC),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    CustomIcon.image_add,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
                isCollapsed: true,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Material(
            shape: CircleBorder(),
            color: kColorDark,
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () async {
                if (message != null) {
                  await widget.group.collection('messages').add({
                    'message': message,
                    'sentBy': widget.sender,
                    'timeSent': Timestamp.now(),
                    'isReply': false,
                  }).then((value) async =>
                  await widget.group.update({
                    'updatedAt': Timestamp.now(),
                  }),);
                  ctrl.clear();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  (message?.isEmpty ?? true)
                      ? CustomIcon.mic
                      : Icons.send_rounded,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
