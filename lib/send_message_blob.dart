import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

class SendMessageBlob extends StatelessWidget {
  const SendMessageBlob({
    super.key,
    required this.size,
    this.replyRef,
    required this.message,
    required this.time,
    this.isFirst = false,
    this.isLast = false,
    this.isRecieved = false, required this.name,
  });

  final DocumentReference? replyRef;
  final String message;
  final DateTime time;
  final bool isFirst;
  final bool isLast;
  final Size size;
  final bool isRecieved;
  final String name;

  @override
  Widget build(BuildContext context) {
    bool last = isLast && !isFirst;
    return Row(
      children: [
        if (!isRecieved) Expanded(child: SizedBox()),
        Column(
          crossAxisAlignment:
          isRecieved ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: isFirst ? 5 : 1,
            ),
            if (isFirst) const Text('You'),
            if (isFirst) const SizedBox(height: 5),
            Material(
              color: isRecieved ? Color(0xffd9d9d9) : kColorDark,
              shape: RoundedRectangleBorder(
                borderRadius: (isRecieved)
                    ? BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: (isFirst) ? Radius.circular(15) : Radius.circular(3),
                  bottomLeft:
                  (last) ? Radius.circular(15) : Radius.circular(3),
                  bottomRight: Radius.circular(20),
                )
                    : BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: (isFirst) ? Radius.circular(15) : Radius.circular(3),
                  bottomRight:
                  (last) ? Radius.circular(15) : Radius.circular(3),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Container(
                constraints:
                BoxConstraints(maxWidth: (size.width - 20) * 4 / 5,minWidth: 65),
                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                child: Column(
                  crossAxisAlignment: isRecieved
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    if (replyRef != null)
                      Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // if (replyRef != null)
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Alex',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.reply_rounded),
                                      Text(
                                        'Reply',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Hello',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (replyRef != null) const SizedBox(height: 10),
                    Row(
                      mainAxisSize: (replyRef != null)
                          ? MainAxisSize.max
                          : MainAxisSize.min,
                      mainAxisAlignment: (replyRef != null)
                          ? MainAxisAlignment.spaceBetween
                          : isRecieved
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        if (!isRecieved) SizedBox(),
                        Flexible(
                          child: Text(
                            message,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: isRecieved ? null : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (!isRecieved) SizedBox(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        DateFormat.jm().format(time),
                        textAlign: TextAlign.end,
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color:
                          isRecieved ? Colors.grey.shade600 : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // if (isRecieved) Expanded(child: SizedBox()),
      ],
    );
  }
}