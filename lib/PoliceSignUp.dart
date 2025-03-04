import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahikav/components/text_form_field.dart';

import 'components/buttons/filled_buttons.dart';

class PoliceSignUp extends StatefulWidget {
  const PoliceSignUp({Key? key}) : super(key: key);

  @override
  State<PoliceSignUp> createState() => _PoliceSignUp();
}

class _PoliceSignUp extends State<PoliceSignUp> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Form(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    CustomTextFormField(
                      label: 'Email ID',
                      controller: emailCtrl,
                      hint: 'abc@example.com',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      label: 'Police ID',
                      controller: emailCtrl,
                      hint: 'abc@example.com',
                    ),
                    SizedBox(
                      height: 10,
                    ),CustomTextFormField(
                      label: 'ID Proof',
                      controller: emailCtrl,
                      hint: 'Eg.Aadhar Card, Pan Card etc... ',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                        label: 'Password', controller: passCtrl),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                        label: 'Confirm Password', controller: passCtrl),
                    SizedBox(
                      height: 20,
                    ),
                    CustomFilledButton(
                      onPressed: () {},
                      label: 'Sign Up',
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
