import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mahikav/constants.dart';

import 'components/buttons/filled_buttons.dart';
import 'components/text_form_field.dart';

class AddPlace_Admin extends StatefulWidget {
  const AddPlace_Admin({Key? key}) : super(key: key);

  @override
  State<AddPlace_Admin> createState() => _AddPlace_AdminState();
}

class _AddPlace_AdminState extends State<AddPlace_Admin> {
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Community'),
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
              label: 'City',
              controller: cityCtrl,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextFormField(
              label: 'State',
              controller: stateCtrl,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: CustomFilledButton(
          onPressed: () {
            firestore.collection('communities').add({
              'city': cityCtrl.text,
              'state': stateCtrl.text,
            }).then(
              (value) => value.collection('groups').add({
                'isGeneral': true,
                'updatedAt': Timestamp.now(),
              }),
            );
          },
          label: 'Create',
        ),
      ),
    );
  }
}
