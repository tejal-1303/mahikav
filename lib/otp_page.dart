import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahikav/home_page.dart';

import 'constants.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({
    Key? key,
    required this.verificationId,
    this.data,
  }) : super(key: key);
  final String verificationId;
  final Map<String, dynamic>? data;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  // final List<FocusNode> focusNode = [];
  final List<TextEditingController> controllers = [];
  String? errorText;
  Timer? timer;
  Timer? resendTimer;
  bool isSent = false;

  // String? verifyOTP;
  int? tick;

  // IOWebSocketChannel? _channel;

  @override
  void initState() {
    // focusNode[i].dispose();
    for (int i = 0; i < 6; i++) {
      // focusNode.add(FocusNode());
      controllers.add(TextEditingController());
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    resendTimer?.cancel();
    for (int i = 0; i < 6; i++) {
      // focusNode[i].dispose();
      controllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        leadingWidth: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Verify your Account',
              style: GoogleFonts.poppins(
                  fontSize: 28, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: List.generate(
                  6,
                  (index) => Flexible(
                    child: OTPBox(
                      errorText: errorText,
                      controller: controllers[index],
                      // focusNode: focusNode[index],
                      onChanged: (value) {
                        if (controllers.length > 1 && index < 5) {
                          controllers[index + 1].text =
                              controllers[index].text.substring(index + 1);
                          setState(() {});
                          controllers[index].text = controllers[index + 1].text.substring(index,index + 1);
                        }
                        if (index == 5) {
                          FocusScope.of(context).unfocus();
                          continueFunction();
                          return;
                        }
                        print('1 : ${controllers[0].text}');
                        print('2 : ${controllers[1].text}');
                        print('3 : ${controllers[2].text}');
                        print('4 : ${controllers[3].text}');
                        print('5 : ${controllers[4].text}');
                        print('6 : ${controllers[5].text}');
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  child: Text(
                    'Resend?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kColorDark,
                    ),
                  ),
                  onPressed: (tick == null || tick != 0) ? null : () async {},
                ),
                const SizedBox(
                  width: 5,
                ),
                if (tick != null && tick != 0)
                  Text(
                    '$tick s',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void continueFunction() async {
    String otp = '';
    for (int i = 0; i < 6; i++) {
      if (controllers[i].text.isEmpty) {
        return;
      }
      otp += controllers[i].text;
      controllers[i].clear();
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    // Sign the user in (or link) with the credential
    await FirebaseAuth.instance.signInWithCredential(credential);
    if (widget.data != null) {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set(widget.data!);
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
      (_) => false,
    );
  }
}

class OTPBox extends StatelessWidget {
  const OTPBox({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        cursorColor: Colors.black,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          fontFamily: 'SourceSansPro',
        ),
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isCollapsed: true,
          contentPadding: const EdgeInsets.all(5),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: (errorText != null)
                  ? Colors.red.shade800
                  : (controller.text.isNotEmpty)
                      ? Colors.black
                      : const Color(0xffD8DADC),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: (errorText != null)
                  ? Colors.red.shade800
                  : (controller.text.isNotEmpty)
                      ? Colors.black
                      : const Color(0xffD8DADC),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: (errorText != null) ? Colors.red.shade800 : Colors.black,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        controller: controller,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else {
            FocusScope.of(context).previousFocus();
          }
          print(controller.text);
          onChanged(value);
        },
      ),
    );
  }
}
