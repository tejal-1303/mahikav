import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'components/custom_icon_icons.dart';

class EmergencyButtons extends StatelessWidget {
  const EmergencyButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          backgroundColor: Colors.red.shade900,
          child: Icon(
            CustomIcon.mic,
            color: Colors.white,
          ),
          onPressed: () {

          },
        ),
        SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.call,
            color: Colors.white,
          ),
          onPressed: () async {
            await FlutterPhoneDirectCaller.callNumber('+917021051913');
          },
        ),
      ],
    );
  }
}
