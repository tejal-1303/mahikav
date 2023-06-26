import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mahikav/components/custom_icon_icons.dart';

import 'components/buttons/filled_buttons.dart';
import 'components/text_form_field.dart';

class AddCollege_Admin extends StatefulWidget {
  const AddCollege_Admin({Key? key, required this.community}) : super(key: key);
  final DocumentSnapshot community;

  @override
  State<AddCollege_Admin> createState() => _AddCollege_AdminState();
}

class _AddCollege_AdminState extends State<AddCollege_Admin> {
  final collegeName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add College'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              label: 'College Name',
              controller: collegeName,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: CustomFilledButton(
          onPressed: () {
            widget.community.reference.collection('groups').add({
              'collegeName': collegeName.text,
              'isGeneral': false,
              'updatedAt': Timestamp.now(),
            });
          },
          label: 'Create',
        ),
      ),
    );
    ;
  }
}
