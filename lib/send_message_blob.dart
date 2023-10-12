import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
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
    this.isRecieved = false,
    required this.name,
    this.fileMessage, required this.audioPlayer,
  });

  final DocumentReference? replyRef;
  final String message;
  final DateTime time;
  final bool isFirst;
  final bool isLast;
  final Size size;
  final bool isRecieved;
  final String? name, fileMessage;
  final AudioPlayer audioPlayer;

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
            if (isFirst) Text(name ?? ''),
            if (isFirst) const SizedBox(height: 5),
            Material(
              color: isRecieved ? Color(0xffd9d9d9) : kColorDark,
              shape: RoundedRectangleBorder(
                borderRadius: (isRecieved)
                    ? BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: (isFirst)
                            ? Radius.circular(15)
                            : Radius.circular(3),
                        bottomLeft:
                            (last) ? Radius.circular(15) : Radius.circular(3),
                        bottomRight: Radius.circular(20),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: (isFirst)
                            ? Radius.circular(15)
                            : Radius.circular(3),
                        bottomRight:
                            (last) ? Radius.circular(15) : Radius.circular(3),
                        bottomLeft: Radius.circular(20),
                      ),
              ),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: (size.width - 20) * 4 / 5, minWidth: 65),
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
                          child: Builder(builder: (context) {
                            if (fileMessage != null) {
                              return MessageAudioPlayer(
                                url: fileMessage!, audioPlayer: audioPlayer,
                              );
                            }
                            return Text(
                              message,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: isRecieved ? null : Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }),
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
                          color: isRecieved
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
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

class MessageAudioPlayer extends StatefulWidget {
  const MessageAudioPlayer({super.key, required this.url, required this.audioPlayer});

  final String url;
  final AudioPlayer audioPlayer;


  @override
  State<MessageAudioPlayer> createState() => _MessageAudioPlayerState();
}

class _MessageAudioPlayerState extends State<MessageAudioPlayer>
    with SingleTickerProviderStateMixin {
  int tick = 10;
  Timer? timer;
  bool disableCancel = true;
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.stop);
    // if (widget.url == null) {
    //   final result = await FilePicker.platform.pickFiles();
    //   if (result != null) {
    //     final file = File(result.files.single.path!);
    //     await audioPlayer.setSourceAsset(file.path);
    //   }
    // } else {
    final file = File(widget.url);
    await audioPlayer.setSourceUrl(file.path);
    // }
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final mins = twoDigits(duration.inMinutes.remainder(60));
    final secs = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      mins,
      secs,
    ].join(':');
  }

  @override
  void initState() {
    super.initState();
    setAudio();
    // timer = Timer.periodic(const Duration(seconds: 1), (time) {
    //   if (time.tick == 10) {
    //     timer?.cancel();
    //     disableCancel = false;
    //   }
    //   tick--;
    //   setState(() {});
    // });
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                iconSize: 20,
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    await audioPlayer.resume();
                  }
                },
              ),
              Expanded(
                child: Slider(
                  min: 0,
                  max: duration.inMicroseconds.toDouble(),
                  value: position.inMicroseconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(microseconds: value.toInt());
                    await audioPlayer.seek(position);
                    await audioPlayer.resume();
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
