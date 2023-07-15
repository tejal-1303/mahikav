import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'custom_icon_icons.dart';

class EmergencyButtons extends StatefulWidget {
  const EmergencyButtons({Key? key}) : super(key: key);

  @override
  State<EmergencyButtons> createState() => _EmergencyButtonsState();
}

class _EmergencyButtonsState extends State<EmergencyButtons> {
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
          onPressed: () {},
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
            await FlutterPhoneDirectCaller.callNumber('+911090');
          },
        ),
      ],
    );
  }
}
