import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahikav/components/text_form_field.dart';

import 'components/buttons/filled_buttons.dart';

class LoginSignUp extends StatefulWidget {
  const LoginSignUp({Key? key}) : super(key: key);

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
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
                        label: 'Password', controller: passCtrl),
                    SizedBox(
                      height: 20,
                    ),
                    CustomFilledButton(
                      onPressed: () {},
                      label: 'Login',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CupertinoButton(
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color(0xff27374D),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    Text(
                      'or',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,

                      ),
                    ),
                    SizedBox(height: 20,),
                    CustomOutlineButton(onPressed: () {}, label: 'Create an Account')
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
