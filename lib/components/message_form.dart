import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import '../record_player.dart';
import 'custom_icon_icons.dart';

class MessageForm extends StatefulWidget {
  const MessageForm({
    super.key,
    required this.group,
    required this.sender,
  });

  final DocumentReference sender;
  final DocumentReference group;

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  String? message;
  final ctrl = TextEditingController();
  final recorder = FlutterSoundRecorder();
  Timer? timer;
  bool isRecorderReady = false;

  Future record() async {
    await recorder.startRecorder(toFile: 'audio');
  }

  Future<String?> stop() async {
    timer?.cancel();
    return await recorder.stopRecorder();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 1));
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future onPost(String url_) async {
    File file = File(url_);
    String fileName = DateTime.now().toIso8601String();
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('audio/$fileName.aac');
    UploadTask uploadTask = firebaseStorageRef.putFile(
        file, SettableMetadata(contentType: 'audio/aac'));
    String url = await uploadTask.whenComplete(() {}).then((value) {
      return value.ref.getDownloadURL();
    });
    // Position curPos = await _determinePosition();
    // List<Placemark> placemarks =
    //     await placemarkFromCoordinates(curPos.latitude, curPos.longitude);
    // placemarks[0];
    // String? name;
    // if (FirebaseAuth.instance.currentUser != null) {
    //   final user = await FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(FirebaseAuth.instance.currentUser!.uid)
    //       .get();
    //   name = user['name'];
    // }
    // final address = placemarks.first.toJson();
    // print(address);
    await widget.group.collection('messages').add({
      'fileMessage': url,
      'message': "",
      'sentBy': widget.sender,
      'timeSent': Timestamp.now(),
      'isReply': false,
    }).then(
      (value) async => await widget.group.update({
        'updatedAt': Timestamp.now(),
      }),
    );
    // await FirebaseFirestore.instance
    //     .collection('emergency')
    //     .add({
    //   if (name != null) 'name': name,
    //   'audio': url,
    //   'address': address,
    //   'isCreated': DateTime.now().toUtc(),
    // });
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: kColorLight,
        // border: Border(top: BorderSide()),
      ),
      child: Row(
        children: [
          Flexible(
            child: StreamBuilder<RecordingDisposition>(
                stream: recorder.onProgress,
                builder: (context, snapshot) {
                  if (snapshot.hasData&&recorder.isRecording) {
                    return Slider(
                      label: snapshot.requireData.duration.toString(),
                      value: snapshot.requireData.duration.inMicroseconds
                          .toDouble(),
                      divisions: const Duration(minutes: 1,seconds: 30).inMicroseconds,
                      max: const Duration(minutes: 1,seconds: 30).inMicroseconds.toDouble(),
                      onChanged: (val) {},
                    );
                  }
                  return TextFormField(
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
                        color: const Color(0xffD8DADC),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          CustomIcon.image_add,
                          size: 28,
                        ),
                        onPressed: () {},
                      ),
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  );
                }),
          ),
          const SizedBox(
            width: 10,
          ),
          Material(
            shape: const CircleBorder(),
            color: kColorDark,
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () async {
                if (message != null && message!.isNotEmpty) {
                  await widget.group.collection('messages').add({
                    'message': message,
                    'sentBy': widget.sender,
                    'timeSent': Timestamp.now(),
                    'isReply': false,
                  }).then(
                    (value) async => await widget.group.update({
                      'updatedAt': Timestamp.now(),
                    }),
                  );
                  ctrl.clear();
                } else {
                  await HapticFeedback.lightImpact();
                  if (recorder.isRecording) {
                    await stop().then(
                      (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecordPlayerLocal(
                            url: value!,
                            onPressed: () async {
                              await onPost(value);
                            }, isEmergency: false,
                          ),
                        ),
                      ),
                    );
                  } else {
                    await record();
                    timer = Timer(const Duration(minutes: 1, seconds: 30),
                        () async {
                      await stop().then(
                        (value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecordPlayerLocal(
                              url: value!,
                              onPressed: () async {
                                await onPost(value);
                              }, isEmergency: true,
                            ),
                          ),
                        ),
                      );
                    });
                    setState(() {});
                  }
                  ctrl.clear();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  (message?.isEmpty ?? true)
                      ? recorder.isRecording
                          ? Icons.stop_rounded
                          : CustomIcon.mic
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
